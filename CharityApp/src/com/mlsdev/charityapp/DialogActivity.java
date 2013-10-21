package com.mlsdev.charityapp;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.ActionBarActivity;
import android.widget.Toast;


/**
 * Created by android-dev on 30.08.13.
 */
public class DialogActivity extends ActionBarActivity {


    private ProgressDialog mProgressDialog;

    public void showProgressDialog(){
        mProgressDialog = Utils.showProgressDialog(getString(R.string.sending_request),this);
    }

    public void closeProgressDialog(){
        if (mProgressDialog != null) mProgressDialog.cancel();
    }

    public void showErrorToast() {
        Toast.makeText(this, "Error! Please check internet connection!!!", Toast.LENGTH_SHORT).show();
    }

    public void updateProgressDialogMessage(Integer value) {
        mProgressDialog.setMessage("Your request was sent. Please wait for users reply! " + value);
    }

    public void showEmptyValueToast() {
        Toast.makeText(this, "Please enter value!", Toast.LENGTH_SHORT).show();
    }

    public void showResendSuccessToast() {
        Toast.makeText(this, "Please wait for new code!", Toast.LENGTH_SHORT).show();
    }

    public Dialog showDialog(String name, String category, final String phoneNumber){

        AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

        // set title
        alertDialogBuilder.setTitle(name);

        // set dialog message
        alertDialogBuilder
                .setMessage(getString(R.string.people_find_text, category))
                .setCancelable(false)
                .setNegativeButton("Call him",new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog,int id) {
                        String uri = "tel:" + "+"+phoneNumber.trim() ;
                        Intent intent = new Intent(Intent.ACTION_CALL);
                        intent.setData(Uri.parse(uri));
                        startActivity(intent);
                    }
                })
                .setPositiveButton("Cancel",new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog,int id) {
                        // if this button is clicked, just close
                        // the dialog box and do nothing
                        dialog.cancel();
                    }
                });

        // create alert dialog
        AlertDialog alertDialog = alertDialogBuilder.create();

        // show it
        alertDialog.show();
        return  alertDialog;
    }
}
