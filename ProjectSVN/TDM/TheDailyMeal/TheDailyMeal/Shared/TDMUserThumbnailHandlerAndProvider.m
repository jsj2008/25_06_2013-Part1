//
//  TDMUserThumbnailHandlerAndProvider.m
//  TheDailyMeal
//
//  Created by Aswathy Bose on 08/03/12.
//  Copyright (c) 2012 Rapid Value Solutions. All rights reserved.
//

#import "TDMUserThumbnailHandlerAndProvider.h"

@implementation TDMUserThumbnailHandlerAndProvider

- (void)signUpWithProfileImage:(NSString *)imagePath userId:(NSString *)userId
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"5892" forKey:@"filesize"];
    [dict setObject:@"filename" forKey:@"filename"];
    [dict setObject:@"1" forKey:@"status"];
    NSString *image = @"\/9j\/4AAQSkZJRgABAQAAAQABAAD\/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7\/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7\/wAARCAB9AH0DASIAAhEBAxEB\/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL\/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6\/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL\/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6\/9oADAMBAAIRAxEAPwD3BZxCw2OpToST0NaViYXbzGccc4ryrwpJrGvaiJrszQWifM+5du5uwUZrp2vJ9PmaCViwX7p9RXxnM6ejPvJxhLRSOp1KXeSUPFcvqqHOc5ph1rzWG04HfNULy+IlDuuUJ6d65pNy1FFxpxsVbi6CKVGecisy+lkW2LZ3BeV4rQVc75kHKtnB5zWZcwXWrMLGwieS5kchUQdaqnBt2MKlS+pxurGaaaS\/UFWiO4J\/s9xUkWi6lrOoww2cv2eDYHkfPOD2FevaF8JxcWMjavqk1q0KZkiisnyo74Zh8x+gqKTwhfaSo1Pw9rMEumsPLaW8hFqI19d0owfqvOe1evSy2vJcyS+ZxvH0U7XPOR4cFlckQC4nuGBG+Rs4HfFY+swTsotY14\/5aH+lfQuj+ErbSdPvbnXr+0ltBEJmxcO7KOuWA5br+Jq7olh4JZ7e3t9IguZr2IzxGezkA8sZ5JYfLnB64zW0csqJ3m0RPNKbi1FM+ctIj+xaRJM7MSj5C9iaSLVbwzBZHUGQ5G5ep9K93+JPw+8PSeFdQ1fTYZbWURqYoIAFjaQEDofX614NDFPDKyC2JaN9pyMFCPUHkGsqmEcJaq5zwrxqK6JYIxf74WbBwW3d19a6zwNe3lhY3unuMZZck\/Tt9ayvDqwT3KNcRJHg5VgM\/Wu80jSYZjEyOtwGIzsBCqO2SR2rCmlz2Lm1Y1fB+nTT3CXC5JkfaAB2\/iP4CvZ4UCRqijAUYFc14bi03TrZd1zE8zDaSqkKgHYf55rpoXSWNZI2DowyGB4Ir2MPFczZ5OJnzM+a9E1sifYgjWJQVGOMtg4Aqew1X7bELe52mUnMbnuOteDeHo\/H18kkKQlMsWWVidzZJJPt+NejeFXv\/sAS63G4hbhl4UsAcgfnXhVsPybs+g95K51cislw6sGVWb5WIx2yMVnajqFwkclvNDkKAw55x6VaeNLm2G2UrjbLgHn6isqeQS5MqF5VJ2ZHXPBGK5407tJF84XOuQQ2Ms7F18gAYyPmJxgA1wer+IdduC76deNBMARGsQ4XPoTzn3\/lXsui3fh7w\/q03gvxpZaeIJ7cTNMIy4XcufLc4zvHqvTIFYeleB9FS8uNTt7p7LRGmYwXOpAK23PChRy59PbrX2GX4LB4KDeNg1Jq6f8Al\/meNiMVUrO1F6HQfBP4m3FpounaZ4g1+fViY8zXEkcrTW8pP+rf5MFVA6lsn6cVauNd+HtratAsF34nvjdG6NxqZYo0nrgnAAHCjbgU7Wr7wX4c0Bb690DxHe2O5VN40JgiZucY6dea5vRdR+Bniu8XT5bLUtHlmbCyG7dVJ+oOPzFck8Ryuy\/Jmfsutjv9O+KmjI0kt3FpNo7gMcKSx+vc4p5+NOhK6hryFxjDCOE9c9sn0rHvP2ePCSK00Os6rHDnd8zq+B9cfSptD+EXw8stTj86W5viJP8AUz3PyMD0yBjpn9KwqY3ldpSt8hRhCSukb0PjGy8ZWclrY6VfXkBYZkis9wGOepyua4rxh4Ln+0S30cWptdXDeY73KneT07e2K7j41+IrjwT4Ps7XQIUslnkMStCgHlIBkhR0BPr9a+d\/FnjKHUorZrKzurC7jB+0TLfSP5x7EhuhrX6xUpT5qbu132KppSXZHaahb6Vp2iadMZmTWNxiu4GQqGOTtY5H0GR+NdB8PNXv4Lx41Hl73w0e37reo9c15Z4X8ZXc91Fp+r3cFzZMcH7YCdnHBDD5l+tepeB4IbfXrZGunWwlYBZCys9szfdy3Ro26BhXnTvKd5Kzf3HVtHe57jo017NCpuoEQjgkfSrGk\/8AHhHxjr\/M1nx6EyL8usaoO5xMMZ\/KtSxtxa2qW6yPIEGNznLH617FCMopXPJm072PlWNNUnklQqkEQwcqOoNXrCxeKNvMLHK7fmGeP7w962vNt58BE4aTacfd5PalV1kv3iEZwoAz244wPxr5acvePpXUlLc59ke0t2VmBQj5Ru5544P4Vw\/jfxMdJ01dLtrQ3d7cPthlldlWFhznIIJYcHHT1r0\/VLRZvKhhmWOV3PDD6nGO\/c4HpXjXxY0m4s\/iPpfhX7dFeX161vGJI02+W8+3dxk8gYOa9PKkvac8um3qcGMnL2fLHqaugSadoHh0+LPETSahJNKVtIpG+a+mAwzMe0anj8MetfQPwG01tX8Mp4+8VeVc3t2Ge0MoHlWluvTy16L0Jz1wBXyh8dNQa48dyaHpkb\/Y9MI06ygRSSFj+XgDqSck+ppdO+I\/jDRvDt34YuNQv\/7PeLyvssjlVjX0AIyB7CvUVaeIqe3qavocUuWnD2cdDv8A9pf4ot4r1Y6Tptww0qzchI1PErf32\/p6CvGLTUHRxEE+YnggHcKy7nUHZmYDhjyRXo\/wG8Cv4h1dfEWsq0Hh\/T33yzPwJ3HIjX17ZI6DjqaKs0k5TJp6tRifSfiXxDqWi\/s4wTzTyR6o2nRojH7wOAcn\/gOK+W9M8Wa\/a6lFey6ldMUcMV3n5hnkV9BfFPV4Lrw1uuo28\/UJEh061x\/q4QwLuw98D9BXC6dYWk9y0P2O0OOGIQV5FOUZJyktzu9nKK912PZ\/Eslv8QfhzBZvMIruWFbizmPKuwHB\/oRXyp4jTUtI1abT9UtXtrmJtrKe47EeoPrXuugaouhWq6BewMdND7oSjfNAT3Q+nfFTeMNM03WbNYNftF1C3H+ov4MCaL6\/4dKxhXdGXvaor2SlG0T54trw+YMZ\/EV6H4A8VSae6wTg3FqQQqMfu56j\/dPcfjVLV\/hbqAkM3hzU7bVIeoidhFMPbB4P51T0vwj4ttrtYJPD+oKzNx+6JH5jiux1aVWOjuYpTg9UfYnw516PUrE2Ek3mT28aSRMzZaWBvuMfUjBU+49662vnbTfENt4J8deCdOvbtEkawe31HB4RZHJQH6HH619DqwKgggg9wa9LC1HKmjgxEFGbsfLFzqCxqwhIj+bcOxBH\/wBaq48Qrb3y3ERDrkZAbnHdq4C28SpqllNd29xseLB2MQN\/HJA6kc0y0vlv3LtOtvHn52Y4Cnvt9q+edCaep7raXU6jxfq2rahHZ\/2IqTTwztLMkpKJ5CoxYs3YDvjn868M0LxJcv8AGvw\/q1yTPJHqsEjDcTkmQcDPPAwBXoGrappl3pWo2KX0qpHbmU+S2GYLjr\/s5IzXgunagYvF1nqOSDFdrMCO21gR\/KvXwFDlpttannYupaSSZ9Z\/EPwbrng34zWnxG0bR5Ne0xb03qRxZIDHOVbaCVIJODivP\/iDpnxG+KPxBv8AxFb+D9RhW5ZVSNoyscSKoABdgoPTrXa3HjjxFpc\/m6NqtxbwT\/vfL4ZctznDZwatLr3jDXIfMvtVultwMyO7+WgH1GK544yVOCVrm0sIpvmbOb8J\/CHS9GlW88dajDcTA5XSrGTfuPpJIO3sv516w93aWdnaXOrW8VlpcOEsNMgXaHI6DaPz\/wA5rze48Y6FoamHRYk17V3OEYtiFW+vf8K3NN0LVJgPEvii8k1LVpFKxRx\/LDbIeqovT8e9cOIq1KjUqj06I6aNKMVaKNi8tv7RvbjxLqbuJ\/KzBEvKwKBwPrXlOs+ONL0y9LSyTTOT91B3969K1W9VdNuGDlUdMMCvOMdq+fPE6eGprsPOmo28yk+YEdWSY+ozyv61vg487fOTiHyxvE9Bn+LVrBaFjptrOrKAFMeD+YPWtjwdrusa1pN94l8NSs1zZkfbNMk5SePH3h6MP1718\/SvDJKy8rHn5QDyor6D\/Zg+y6fpGpzSSMGncBSRyyAdx6V04qlCnS5rHNQm5Ts9i3p3jzwvrcnlXgk0TUc4ZH+Vd3selaNxea3axM9tq0skGPlaOQsDXGfGLSNJg1kxx2axi5UyRSBgWU+4rgNA1XVfD+qQRRXEi20zH92TlT68GuOGGhUXNHTyZ1ubg9djQ8U+IJbrxPcTPcPI8ZCbmOSSBz\/WvdPCvxq8YWWh2kBk0+6jWBFjM0OGVQMDkHn8fSvlrW7xH1+9dAApncgA5716RpEpGl2qknKxKD+Ve3RglFI8mrJSm7ni4vpRISsrrnrgkZq1\/b99HvCXJUN1UdMelZBjbcBinIpLciupxT3Ryc0l1NBr26NpeXfmOWCCMkt\/C3GK5qN\/9IVj2NbFyZRpt2qRsUGzc3YHPArC6GnGKVwbfU+k7LxvoegfDLR9Xv7dL\/U5LbEcZ6ZBIGfyrzfxJ458ReK4i9zdOlr2toziNfwFcFBObi1+yOSxX\/V5PT2FdP4QiWe22LgupwwrgeFhRvN6u530686rUFoN8N397b6h9rEpE8OGRT0OD0xXv\/hf4k6Z4r0xLe5mFreQ4EkcjZ3Hplf8K8T1TTX0yeOZE3RSkZOfun3qro8NtF4mVomIimGMA8o1ZVqVLEx5ux00pTovlPbfE3iBYQ0Xmh4x8o3Y\/mK8w1qK2upTK0qAdTlsY+ma2dS8NXN3aGSynmnjUlGzkNGw6gj1riNZ8M6pBE0rozKh5Oe1FGnFLc3xCml8N0WbW2057hsXCsR0Gc11\/h7WbuwUwWUmwnA3L2FcloPh27YpIU2qfWq9\/dmw8SOrx744CECbjhjjv+Nazgp6XuYU37OKlJWOv1bVZtV8VwjzTMttAULHu3U1zviG9+0O6x422sTc5\/iNOa6bTtJe6cKtzc58oAdM96xbWF3s7l2OSV3Nk8kZ5qaVJXutkRiKvu8q6lbTla4vYoV5LuEH4nFewIfLQRqBhRgfSvLPh\/bmfXRMwykIMhHbPQfzr0vzvbFd6R5qR4+FBlcY6dKliRVBc9qaM+acDGamkUkLGoJJParTMyS+cR+FjBt\/4+JtxPqRwK489a7\/AFTTZl0P7NMoEpBZU7jPTPoa4BwVYqwIYHkGlEbNrwHpH9veM9H0czi3S7vI4pJiwAiQsN7kn0XJ\/Cuz+K2uabH8X9U1DwxYrYaOkiRafCsexZLdFCq+P9vaWz1O7NcD4fvIdP1JbudGcIjbVXuxBAz7c0\/xJrN3r+u3GrXpXzZ2HCjCooAVVA7AKAB9KJLm91rQ0hLlV1uewaPPYa5p4mtwku7iSBzyrHt\/gazU0u3S689F2rbSBsNxtIIPNed6Hq8+l3UdwhZGA2t1+ZT6jvXZ2ni6wubxFvZULMm1pF+7IPf0I968t4edGXu6xPUjiYVkufRn0l8P49M0zQZda8TNZWdzqEnnFZJMKVxgEKe5AzVjWdQ8Aa1ayWUOq6MryrjBkC5r531PUI2uA0t5JKojxGZG3BR2wfT6Vz9xq0MLkkE7eN2Mqfoaj6rzao9elj8LCCjJM+oNG8ERw6fFBBYx3KkfK6\/vAw9QwyDWT42+BEeqWh1PS7YWuqx\/M0JOFuB6cnhvQ14TpvxF1HTrX7Npd5fRA\/eWKZkQ1V1\/xjrztC661eqZE3MVmbOc+uaUMNVjK6di8TicucPjv5KP\/BRm+LW1HT\/Es1prmnz2tzb\/ACG1l+Ux46D6e\/eqVlqxgE0k3KSRuhUd8jAAHtVTxJrep65fR3mqX017NHEsQklbLbR0Ge9FiiuoEoAUcV6cYcsUmfK1Zp1G4vTzO18CWQs9FW7YqZLr5uOSoHQf1reM5PVMfjWX4fZo9KT5dkZ+4vt61eZiMYUGtFqR0PO0Qtc7VBJJwAB1rs9I0lNLt\/tt6Fa8I\/dxnnyvc+\/8q5nTrn7Ferc+X5jR5ZR79quP4lt71sF9kndX4NKVzMs30rSSOzOGLZINc5qunW14S+7yp+7AZDfWr91eoQx3A\/SsuS+hDZLZA9KWqAx77Tbm0G5wHj\/vpyKpr1rdOpFSSjcZ6HpVeW4tJSWltk3E\/eQ4q1JisOtbS+uLPzo4UliHy5LoD+ROapSQXCFiInUDg45xVny7UwsI5cZIPzDp+NQPHKifKdy\/7LUIZf0rWTCqWt7ve29R95fpU+orp0hD2t3uB7NxisHI3cjNLFjJ4pOCvctTdrGvixt4jKZvOf8AhRPX60viiCfT9WlsJZY5HhCq5jOVDFQSM+2cfUGs62JF1FsXeVYPt9cc1cuQ099Jdznc8zGTGc4zzS5bMTloV4InlIyDXQ6bZJIFUnn0qjbKN2cY960IXkU4t42Y45IHWpk7iTO6tNv9ixBUBEOFDA5wPSq7TBDyAapaTJcLa\/vmBDDIVeg+tJJNjGBk804J2LZgzTaSwWKxuRM5P3mYAn6DtXOanNp3mkBJJZBwWUgD8+9dtqegWDkwxwxwheAUTBH41m6f4MspdTt4prqZ45JkVgAAcFgDzRHchu+xl6V4I8X6xo0mtaT4d1W50xCc3CREocdcHv8AhWDBa3dxex2UEEslzJII0iVSXZicAAdc5r9CLbXdPsfDsWj2ehxw2VvEI4ollwqqBgfw14Bp9lp2j\/tA2GuQWSPu8yUQseFk2kBwcdfwrjp42UpNOOnQ9CeBioKSlrf8zybxH8J\/Hugael9qehTRxMu4hGDso9wOlcTsfOCpr9ENW8Q2+pWDpcaZkOm0jzuMf9818ifFrwxYWfi6SXTv9GiuB5hixuCtnnHSjC4ypUnyVIixOCp04c8JHlixseM4qRFZTkSMD7V0L6Kp\/wCW\/wD45\/8AXqM6IP8An5\/8c\/8Ar133ueeYjKGOWzn1FNCqCcZ596220MY\/4+f\/ABz\/AOvVdtGbOPtX\/kP\/AOvTAufD7w5d+J\/GFjpFjG8kkpZmKsBsRVJZsnjgV6Ta\/Cp9Ws76LTLqR9T0yQ280c0QjE0gAbb7HBxnke\/esj4BvL4f+Itvfxus+baaNkK4yCvrzX0lJ4jiF2Z49NRGWRSQJPvHjk\/LXn4qpVjUSjsdeHpwlBuR8ei4SL92QA4OGHuKcl+HlVFXcxIwFWt7xppUY8W6sls4gjkv5iqhM7AXJwPpnFdB4Q8NaBa6HNrN\/pw1KWNiqRSysqZGOSByep4zXRsrswt71jI0uNFt3jFyHZsttJ6fSgsGODtO3itC\/tbG9nE0Wm2ensCCv2NGjx7dTmuZvLOZbuTbdsBuP8P\/ANeqp3CVkf\/Z";
    [dict setObject:image forKey:@"file"];
    NSString *path = [NSString stringWithFormat:@"http://www.thedailymeal.com/rest/app/file/%@",userId];
    [self postRequest:path withParams:dict withRequestType:kTDMSignUpWithImage];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request Failed due to server error");
    [self trackRequestError:request];
    [delegate requestCompletedWithErrors:request];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"From TDM User Profile Request Finished %@",[[request responseString] JSONValue]);
    [delegate requestCompletedSuccessfully:request];
} 

@end
