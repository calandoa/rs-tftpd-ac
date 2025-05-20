#![cfg(feature = "debug_drop")]

use std::error::Error;
use std::sync::atomic::{AtomicU64, Ordering};

use crate::Packet;

/* The 0 to 4 seq numbers (16b) to discard are stored in a atomic u64 */
static TX_DROP: AtomicU64 = AtomicU64::new(0);


pub fn drop_set(opt : Option<String>) -> Result<(), Box<dyn Error>> {
    if let Some(arg) = opt {
        let mut tx_drop = 0u64;
        for val in arg.split(',').rev() {
            let val_num = val.parse::<u16>()?;

            if val_num == 0 && tx_drop == 0 {
                return Err("Last packet to drop cannot have seq == 0".into());
            }

            if tx_drop << 16 >> 16 != tx_drop {
                return Err("Cannot drop more than 4 packets".into());
            }
            tx_drop = tx_drop << 16 | val_num as u64;
        }

        TX_DROP.store(tx_drop, Ordering::Relaxed);
        Ok(())
    } else {
        Err("Missing argument".into())
    }
}

fn check_seq_num(num: u16) -> bool
{
    let tx_drop = TX_DROP.load(Ordering::Relaxed);
    if tx_drop == 0 { return false }

    if num == (tx_drop & 0xFFFF) as u16 {
        TX_DROP.store(tx_drop >> 16, Ordering::Relaxed);
        true
    } else {
        false
    }

}

pub fn drop_check(packet: &Packet) -> bool
{
    match packet {
        Packet::Data{block_num, data: _ } => check_seq_num(*block_num),
        Packet::Ack(block_num) => check_seq_num(*block_num),
        _ => false,
    }
}