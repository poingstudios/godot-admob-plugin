//
//  admob_module.mm
//  admob_module
//
//  Created by Gustavo Maciel on 16/01/21.
//

#import "admob_module.h"

AdMob * admob;

void register_admob_types() {
    NSLog(@"init admob plugin");

    admob = memnew(AdMob);
    Engine::get_singleton()->add_singleton(Engine::Singleton("AdMob", admob));
}

void unregister_admob_types() {
    NSLog(@"deinit admob plugin");
    
    if (admob) {
       memdelete(admob);
   }
}
