package com.example.adtrack;

// The app is to turn a Androiod phone into an iBeacon.
//problem: the app will be killed by Android if the phone runs out of memory

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.bluetooth.le.AdvertiseCallback;
import android.bluetooth.le.AdvertiseData;
import android.bluetooth.le.AdvertiseSettings;
import android.bluetooth.le.BluetoothLeAdvertiser;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import android.content.IntentFilter;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.UUID;


//import static android.graphics.Color.RED;
import static android.graphics.Color.WHITE;
import static java.lang.System.out;


public class MainActivity extends AppCompatActivity {

    @Override

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //set the UI
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);

         TextView tv1 = (TextView) findViewById(R.id.tv1);
        tv1.setTextColor(WHITE);


        TextView bluetoothPermission = (TextView) findViewById(R.id.tv2);
        bluetoothPermission.setTextColor(WHITE);


        TextView tv3 = (TextView) findViewById(R.id.tv3);
        tv3.setTextColor(WHITE);

        //check whether the bluetooth is on
        if(checkBluetooth()){


            startBroadcasting();

        }
        else{

            askForBluetooth();
        }
        //register the listener(blueStateBroadcastReceiver) to listen bluetooth state
        registerReceiver(blueStateBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED));
    }






    /** when the user clicks the ABOUT button, go to aboutvtec page */
    public void aboutVTEC(View view) {
        Intent intent = new Intent(this, aboutvtec.class);
        startActivity(intent);
    }
    public void permitUsingBluetooth(View view){
        unregisterReceiver(blueStateBroadcastReceiver);//if the receiver is still registered,the intent will be sent twice
        Intent enableBluetooth = new Intent(
                BluetoothAdapter.ACTION_REQUEST_ENABLE);//if not on, a pop-up window will appear to ask the user yes or no
        startActivityForResult(enableBluetooth, 1);// send the user's choice to onActivityResult
        registerReceiver(blueStateBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED));

    }

    public boolean checkBluetooth(){
        boolean bluetoothIsOn = true;

        BluetoothManager bluetoothManager;
        BluetoothAdapter bluetoothAdapter;
        bluetoothManager = (BluetoothManager)this.getSystemService(
                Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();

        if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled()) {
            bluetoothIsOn = false;

            TextView tv1 = (TextView) findViewById(R.id.tv3);
            tv1.setText(R.string.Bluetooth_Off);
            tv1.setTextColor(android.graphics.Color.RED);

//            Intent enableBluetooth = new Intent(
//                    BluetoothAdapter.ACTION_REQUEST_ENABLE);//if not on, a pop-up window will appear to ask the user yes or no
//            startActivityForResult(enableBluetooth, 1);// send the user's choice to onActivityResult

        }

        else{

            TextView tv1 = (TextView) findViewById(R.id.tv3);
            tv1.setText(R.string.Bluetooth_On);
            tv1.setTextColor(WHITE);

            //startBroadcasting();
            // didTurnOnBluetooth.start();
        }
        return bluetoothIsOn;
    }


    public void startBroadcasting(){

        BluetoothManager bluetoothManager;
        BluetoothAdapter bluetoothAdapter;
        BluetoothLeAdvertiser bluetoothLeAdvertiser;


        bluetoothManager = (BluetoothManager)this.getSystemService(
                Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();


        //bluetoothAdapter.setName("Android Beacon App Test");
        bluetoothLeAdvertiser = bluetoothAdapter.getBluetoothLeAdvertiser();
        bluetoothLeAdvertiser.startAdvertising(
                createAdvertiseSettings(false, 0),
                createAdvertiseData(
                        UUID.fromString("abefd083-70a2-47c8-9837-e7b5634df524"),
                        888, 333, (byte) 0xc5),
                advertiseCallback);

    }

    public void askForBluetooth(){

        Intent enableBluetooth = new Intent(
                BluetoothAdapter.ACTION_REQUEST_ENABLE);//if not on, a pop-up window will appear to ask the user yes or no
        startActivityForResult(enableBluetooth, 1);// send the user's choice to onActivityResult
    }




    //Turn on the bluetooth if the user chose yes
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        TextView bluetoothPermission = (TextView) findViewById(R.id.tv2);
        bluetoothPermission.setTextColor(WHITE);
        if (resultCode==-1){//if yes is chosen, -1 will be sent here,otherwise resultCode is 0

            startBroadcasting();

            bluetoothPermission.setText(R.string.Bluetooth_Permitted);
            //didTurnOnBluetooth.start();
            }
        else{
            bluetoothPermission.setText(R.string.Bluetooth_Not_Permitted);
            bluetoothPermission.setTextColor(android.graphics.Color.RED);

        }
        //registerReceiver(blueStateBroadcastReceiver, new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED));//register again because the receiver
        // is unregistered in onReceive() when bluetooth is turned off
    }

    //listener for bluetooth state
    BroadcastReceiver blueStateBroadcastReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {

            int blueState = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, 0);
           // TextView tv3 = (TextView) findViewById(R.id.tv3);



            switch (blueState) {
                case BluetoothAdapter.STATE_OFF:
                    Log.i("myTAGfkjddddgkhkllllhl", "blueState: STATE_OFF");

                   checkBluetooth();
//                    tv3.setText("Bluetooth Status:OFF ");
//                    tv3.setTextColor(android.graphics.Color.RED);

                    break;
                case BluetoothAdapter.STATE_TURNING_ON:
                    //didTurnOnBluetooth.interrupt();
                    checkBluetooth();


//                    tv3.setText("Bluetooth Status:ON ");
//                    tv3.setTextColor(WHITE);

                    Log.i("myTAGfkjddddgkhkllllhl", "blueState: STATE_TURNING_ON");
                    break;
                case BluetoothAdapter.STATE_ON:
                    checkBluetooth();

                    Log.i("myTAGfkjddddgkhkllllhl", "blueState: STATE_ON");
                    break;
                case BluetoothAdapter.STATE_TURNING_OFF:
                    checkBluetooth();
//                    tv3.setText("Bluetooth Status:OFF ");
//                    tv3.setTextColor(android.graphics.Color.RED);
//                    Log.i("myTAGfkjddddgkhkllllhl", "blueState: STATE_TURNING_OFF");

//                    unregisterReceiver(blueStateBroadcastReceiver);//if the receiver is still registered,the intent will be sent twice
//                    Intent enableBluetooth = new Intent(
//                            BluetoothAdapter.ACTION_REQUEST_ENABLE);//same as in OnCreate, ask user to turn on bluetooth
//                    startActivityForResult(enableBluetooth, 1);

                    break;
                default:
                    break;
            }
        }
    };


    public AdvertiseSettings createAdvertiseSettings(boolean connectable, int timeoutMillis) {
        AdvertiseSettings.Builder builder = new AdvertiseSettings.Builder();
        //builder.setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_POWER);
        builder.setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY);
        builder.setConnectable(connectable);//set the user's phone as connectible, or for privacy non-connectible in the future
        builder.setTimeout(timeoutMillis);
        builder.setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH);
        //builder.setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM);
        //builder.setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_ULTRA_LOW);
        return builder.build();
    }

    public AdvertiseData createAdvertiseData(UUID proximityUuid, int major,
                                             int minor, byte txPower) {
        if (proximityUuid == null) {
            throw new IllegalArgumentException("proximityUuid null");
        }
        byte[] manufacturerData = new byte[23];
        ByteBuffer bb = ByteBuffer.wrap(manufacturerData);
        bb.order(ByteOrder.BIG_ENDIAN);
        bb.put((byte) 0x02);
        bb.put((byte) 0x15);
        bb.putLong(proximityUuid.getMostSignificantBits());
        bb.putLong(proximityUuid.getLeastSignificantBits());
        bb.putShort((short) major);
        bb.putShort((short) minor);
        bb.put(txPower);

        AdvertiseData.Builder builder = new AdvertiseData.Builder();
        builder.addManufacturerData(0x004c, manufacturerData);
        // AdvertiseData adv = builder.build();
        return builder.build();
    }


    private AdvertiseCallback advertiseCallback = new AdvertiseCallback() {
        @Override
        public void onStartSuccess(AdvertiseSettings advertiseSettings) {
            String successMsg = "Advertisement command attempt successful";
            out.print(successMsg);
        }

        @Override
        public void onStartFailure(int i) {
            String failMsg = "Advertisement command attempt failed: " + i;
            out.print(failMsg);
        }
    };

}

