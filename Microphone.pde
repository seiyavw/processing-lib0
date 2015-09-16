import ddf.minim.*;
import ddf.minim.analysis.*;

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioInput source;

  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

class Microphone {

  private
  Minim minim;
  AudioInput in;
  BeatDetect beat;
  BeatListener bl;

  float data;
  float average;
  int check_ave;
  int cnt;
  int ccnt;

  Microphone() {

    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 512);

    beat = new BeatDetect(in.bufferSize(), in.sampleRate());
    beat.setSensitivity(100);

    bl = new BeatListener(beat, in);

    average = 0;
  }

  void update() {
    for(int i = 0; i < in.bufferSize() - 1; i++) {
      data = (in.mix.get(i)*50);
      average = average*(15.0/16.0) + (data/16.0);
    }
  }
  boolean beatIsOnset() {
    return beat.isOnset();
  }
  boolean beatIsHat() {
    return beat.isHat();
  }
  boolean beatIsKick() {
    return beat.isKick();
  }
  boolean beatIsSnare() {
    return beat.isSnare();
  }

  float leftLevel() {
    return in.left.level();
  }
  float rightLevel() {
    return in.right.level();
  }
  float mixLevel() {
    return in.mix.level();
  }
}
