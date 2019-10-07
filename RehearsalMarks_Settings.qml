import QtQuick 2.0
import MuseScore 3.0
import QtQuick.Dialogs 1.1
import Qt.labs.settings 1.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5

MuseScore {
      menuPath: "Plugins.RehearsalMarks.Settings"
      description: qsTr("This plugin controls the settings for the other rehearsal marks plugins.")
      version: "1.1"
      requiresScore: false
      onRun: {
            if ((mscoreMajorVersion < 3) || (mscoreMinorVersion < 3)) {
                  versionError.open();
                  Qt.quit();
            }else {
                  settingsWindow.visible = true;
                  console.log("sequenceType:", settings.value ("sequenceType", "A"))
            }
      }
      MessageDialog {
            id: versionError
            visible: false
            title: qsTr("Unsupported MuseScore version")
            text: qsTr("This plugin needs MuseScore 3.3 or later.")
            onAccepted: {
                  Qt.quit()
            }
      }
      Settings {
            id : settings
            category : "plugins.rehearsalMarks"
      }
      Window {
            id: settingsWindow
            title: qsTr("Rehearsal marks plugin settings")
            width: 350
            height: 300
            ColumnLayout {
                  anchors.fill: parent
                  GroupBox {
                        title: qsTr("Sequence type")
                        ColumnLayout {
                              RadioButton {
                                    id: aUpperButton
                                    text: qsTr("A, B, C etc.")
                                    checked: settings.value ("sequenceType", "A") == "A"
                              }
                              RadioButton {
                                    id: aLowerButton
                                    text: qsTr("a, b, c etc.")
                                    checked: settings.value ("sequenceType", "A") == "a"
                              }
                              RadioButton {
                                    id: numButton
                                    text: qsTr("Numerical: 1, 2, 3 etc.")
                                    checked: settings.value ("sequenceType", "A") == "num"
                              }
                              RadioButton {
                                    id: meaButton
                                    text: qsTr("Numerical: according to measure numbers.\n(Doesn't work if there's a measure excluded\nfrom measure count before the first special barline.)")
                                    checked: settings.value ("sequenceType", "A") == "mea"
                              }
                        }
                  }
                  RowLayout {
                        Item {
                              // spacer item
                              Layout.fillWidth: true
                              Layout.fillHeight: true
                        }
                        Button {
                              id: cancelButton
                              text: qsTr("cancel")
                              onClicked: {
                                    console.log ("text: ", text);
                                    settingsWindow.close();
                                    Qt.quit();
                              }
                        }
                        Button {
                              id: closeButton
                              text: qsTr("Ok")
                              onClicked: {
                                    var text;
                                    if (aUpperButton.checked)
                                          text = "A";
                                    else if (aLowerButton.checked)
                                          text = "a";
                                    else if (numButton.checked)
                                          text = "1";
                                    else if (meaButton.checked)
                                          text = "mea"
                                    else text = "error";
                                    
                                    console.log ("text: ", text);

                                    settings.setValue ("sequenceType", text);
                                    settingsWindow.close();
                                    Qt.quit();
                              }
                        }
                  }
            }
      }
}