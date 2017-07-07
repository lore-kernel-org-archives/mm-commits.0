From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-a-bunch-more-spelling-mistakes.patch removed from
 -mm tree
Date: Fri, 07 Jul 2017 12:07:20 -0700
Message-ID: <20170707190720.kEaGItoU2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbdGGTHV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sboyd@codeaurora.org, yamada.masahiro@socionext.com


The patch titled
     Subject: scripts/spelling.txt: add a bunch more spelling mistakes
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-a-bunch-more-spelling-mistakes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add a bunch more spelling mistakes

Here are some of the more spelling mistakes and typos that I've found
while fixing up spelling mistakes in kernel error message text over the
past several weeks.

Link: http://lkml.kernel.org/r/20170621142614.12529-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-a-bunch-more-spelling-mistakes scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-a-bunch-more-spelling-mistakes
+++ a/scripts/spelling.txt
@@ -54,6 +54,7 @@ adapater||adapter
 addional||additional
 additionaly||additionally
 addres||address
+adddress||address
 addreses||addresses
 addresss||address
 aditional||additional
@@ -130,6 +131,7 @@ arraival||arrival
 artifical||artificial
 artillary||artillery
 asign||assign
+asser||assert
 assertation||assertion
 assiged||assigned
 assigment||assignment
@@ -149,6 +151,7 @@ atempt||attempt
 attachement||attachment
 attched||attached
 attemps||attempts
+attemping||attempting
 attruibutes||attributes
 authentification||authentication
 automaticaly||automatically
@@ -205,9 +208,11 @@ callibration||calibration
 calucate||calculate
 calulate||calculate
 cancelation||cancellation
+cancle||cancel
 capabilites||capabilities
 capabitilies||capabilities
 capatibilities||capabilities
+capapbilities||capabilities
 carefuly||carefully
 cariage||carriage
 catagory||category
@@ -216,6 +221,7 @@ challange||challenge
 challanges||challenges
 chanell||channel
 changable||changeable
+chanined||chained
 channle||channel
 channnel||channel
 charachter||character
@@ -241,6 +247,7 @@ claread||cleared
 clared||cleared
 closeing||closing
 clustred||clustered
+coexistance||coexistence
 collapsable||collapsible
 colorfull||colorful
 comand||command
@@ -269,6 +276,7 @@ completition||completion
 completly||completely
 complient||compliant
 componnents||components
+compoment||component
 compres||compress
 compresion||compression
 comression||compression
@@ -315,6 +323,7 @@ correponding||corresponding
 correponds||corresponds
 correspoding||corresponding
 cotrol||control
+cound||could
 couter||counter
 coutner||counter
 cryptocraphic||cryptographic
@@ -326,6 +335,7 @@ deafult||default
 deamon||daemon
 decompres||decompress
 decription||description
+dectected||detected
 defailt||default
 defferred||deferred
 definate||definite
@@ -343,6 +353,8 @@ delare||declare
 delares||declares
 delaring||declaring
 delemiter||delimiter
+demodualtor||demodulator
+demension||dimension
 dependancies||dependencies
 dependancy||dependency
 dependant||dependent
@@ -357,11 +369,13 @@ descritptor||descriptor
 desctiptor||descriptor
 desriptor||descriptor
 desriptors||descriptors
+destionation||destination
 destory||destroy
 destoryed||destroyed
 destorys||destroys
 destroied||destroyed
 detabase||database
+deteced||detected
 develope||develop
 developement||development
 developped||developed
@@ -419,9 +433,11 @@ enchanced||enhanced
 encorporating||incorporating
 encrupted||encrypted
 encrypiton||encryption
+encryptio||encryption
 endianess||endianness
 enhaced||enhanced
 enlightnment||enlightenment
+entrys||entries
 enocded||encoded
 enterily||entirely
 enviroiment||environment
@@ -439,6 +455,7 @@ etsbalishment||establishment
 excecutable||executable
 exceded||exceeded
 excellant||excellent
+exeed||exceed
 existance||existence
 existant||existent
 exixt||exist
@@ -467,6 +484,7 @@ failuer||failure
 faireness||fairness
 falied||failed
 faliure||failure
+fallbck||fallback
 familar||familiar
 fatser||faster
 feauture||feature
@@ -564,6 +582,7 @@ independant||independent
 independantly||independently
 independed||independent
 indiate||indicate
+indicat||indicate
 inexpect||inexpected
 infomation||information
 informatiom||information
@@ -682,6 +701,7 @@ messags||messages
 messgaes||messages
 messsage||message
 messsages||messages
+micropone||microphone
 microprocesspr||microprocessor
 milliseonds||milliseconds
 minium||minimum
@@ -693,11 +713,14 @@ misformed||malformed
 mispelled||misspelled
 mispelt||misspelt
 mising||missing
+missmanaged||mismanaged
+missmatch||mismatch
 miximum||maximum
 mmnemonic||mnemonic
 mnay||many
 modulues||modules
 momery||memory
+memomry||memory
 monochorome||monochrome
 monochromo||monochrome
 monocrome||monochrome
@@ -798,6 +821,7 @@ permissons||permissions
 peroid||period
 persistance||persistence
 persistant||persistent
+plalform||platform
 platfrom||platform
 plattform||platform
 pleaes||please
@@ -810,6 +834,7 @@ posible||possible
 positon||position
 possibilites||possibilities
 powerfull||powerful
+preapre||prepare
 preceeded||preceded
 preceeding||preceding
 preceed||precede
@@ -868,6 +893,7 @@ psuedo||pseudo
 psychadelic||psychedelic
 pwoer||power
 quering||querying
+randomally||randomly
 raoming||roaming
 reasearcher||researcher
 reasearchers||researchers
@@ -895,6 +921,7 @@ refernnce||reference
 refrence||reference
 registerd||registered
 registeresd||registered
+registerred||registered
 registes||registers
 registraration||registration
 regsiter||register
@@ -923,6 +950,7 @@ requried||required
 requst||request
 reseting||resetting
 resizeable||resizable
+resouce||resource
 resouces||resources
 resoures||resources
 responce||response
@@ -938,6 +966,7 @@ reudce||reduce
 reuest||request
 reuqest||request
 reutnred||returned
+revsion||revision
 rmeoved||removed
 rmeove||remove
 rmeoves||removes
@@ -1099,6 +1128,7 @@ transfering||transferring
 transision||transition
 transmittd||transmitted
 transormed||transformed
+trasfer||transfer
 trasmission||transmission
 treshold||threshold
 trigerring||triggering
@@ -1167,6 +1197,7 @@ virtaul||virtual
 virtiual||virtual
 visiters||visitors
 vitual||virtual
+wakeus||wakeups
 wating||waiting
 wether||whether
 whataver||whatever
_

Patches currently in -mm which might be from colin.king@canonical.com are

kasan-make-function-get_wild_bug_type-static.patch

