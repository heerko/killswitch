int switchPin = 10;
int lastPos = HIGH;

void setup(){
  pinMode( switchPin, INPUT_PULLUP );
  Serial.begin( 9600 );
  delay( 200 );
  Serial.print( "c" );
  sendState();
}

void loop(){
  sendState();
  delay( 200 );
}

void sendState(){
  boolean currentPos = digitalRead( switchPin );
  if( currentPos != lastPos ){
    if( currentPos == HIGH ){
      Serial.print( "h" );
    } else {
      Serial.print( "l" );
    }
    lastPos = currentPos;
  }
}
