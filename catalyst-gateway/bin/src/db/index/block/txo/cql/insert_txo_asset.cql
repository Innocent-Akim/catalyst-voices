-- Create the TXO Record for a stake address, 
-- Will not overwrite anything if it already exists.
INSERT INTO txo_assets_by_stake (
    stake_address,
    slot_no,
    txn,
    txo,
    policy_id,
    policy_name,
    value
) VALUES (
    :stake_address,
    :slot_no,
    :txn,
    :txo,
    :policy_id,
    :policy_name,
    :value 
);
