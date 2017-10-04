From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt.patch removed
 from -mm tree
Date: Wed, 04 Oct 2017 12:39:58 -0700
Message-ID: <20171004193958.XJsPg-sz9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33238 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTj7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:39:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sboyd@codeaurora.org, yamada.masahiro@socionext.com


The patch titled
     Subject: scripts/spelling.txt: add more spelling mistakes to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add more spelling mistakes to spelling.txt

Here are some of the more spelling mistakes and typos that I've found
while fixing up spelling mistakes in kernel error message text over the
past eight weeks.

[akpm@linux-foundation.org: s/|/||/, per Joe]
Link: http://lkml.kernel.org/r/20170919090818.5989-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Joe Perches <joe@perches.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -53,6 +53,7 @@ acumulator||accumulator
 adapater||adapter
 addional||additional
 additionaly||additionally
+additonal||additional
 addres||address
 adddress||address
 addreses||addresses
@@ -67,6 +68,8 @@ adviced||advised
 afecting||affecting
 againt||against
 agaist||against
+aggreataon||aggregation
+aggreation||aggregation
 albumns||albums
 alegorical||allegorical
 algined||aligned
@@ -80,6 +83,8 @@ aligment||alignment
 alignement||alignment
 allign||align
 alligned||aligned
+alllocate||allocate
+alloated||allocated
 allocatote||allocate
 allocatrd||allocated
 allocte||allocate
@@ -171,6 +176,7 @@ availale||available
 availavility||availability
 availble||available
 availiable||available
+availible||available
 avalable||available
 avaliable||available
 aysnc||async
@@ -203,6 +209,7 @@ broadcat||broadcast
 cacluated||calculated
 caculation||calculation
 calender||calendar
+calescing||coalescing
 calle||called
 callibration||calibration
 calucate||calculate
@@ -210,6 +217,7 @@ calulate||calculate
 cancelation||cancellation
 cancle||cancel
 capabilites||capabilities
+capabilty||capability
 capabitilies||capabilities
 capatibilities||capabilities
 capapbilities||capabilities
@@ -302,6 +310,7 @@ containts||contains
 contaisn||contains
 contant||contact
 contence||contents
+continious||continuous
 continous||continuous
 continously||continuously
 continueing||continuing
@@ -393,6 +402,7 @@ differrence||difference
 diffrent||different
 diffrentiate||differentiate
 difinition||definition
+dimesions||dimensions
 diplay||display
 direectly||directly
 disassocation||disassociation
@@ -449,6 +459,7 @@ equiped||equipped
 equivelant||equivalent
 equivilant||equivalent
 eror||error
+errorr||error
 estbalishment||establishment
 etsablishment||establishment
 etsbalishment||establishment
@@ -481,6 +492,7 @@ failied||failed
 faillure||failure
 failue||failure
 failuer||failure
+failng||failing
 faireness||fairness
 falied||failed
 faliure||failure
@@ -493,6 +505,7 @@ fetaure||feature
 fetaures||features
 fileystem||filesystem
 fimware||firmware
+firware||firmware
 finanize||finalize
 findn||find
 finilizes||finalizes
@@ -502,6 +515,7 @@ folloing||following
 followign||following
 followings||following
 follwing||following
+fonud||found
 forseeable||foreseeable
 forse||force
 fortan||fortran
@@ -532,6 +546,7 @@ grabing||grabbing
 grahical||graphical
 grahpical||graphical
 grapic||graphic
+grranted||granted
 guage||gauge
 guarenteed||guaranteed
 guarentee||guarantee
@@ -543,6 +558,7 @@ happend||happened
 harware||hardware
 heirarchically||hierarchically
 helpfull||helpful
+hybernate||hibernate
 hierachy||hierarchy
 hierarchie||hierarchy
 howver||however
@@ -565,16 +581,19 @@ implemenation||implementation
 implementaiton||implementation
 implementated||implemented
 implemention||implementation
+implementd||implemented
 implemetation||implementation
 implemntation||implementation
 implentation||implementation
 implmentation||implementation
 implmenting||implementing
+incative||inactive
 incomming||incoming
 incompatabilities||incompatibilities
 incompatable||incompatible
 inconsistant||inconsistent
 increas||increase
+incremeted||incremented
 incrment||increment
 indendation||indentation
 indended||intended
@@ -619,6 +638,7 @@ interger||integer
 intermittant||intermittent
 internel||internal
 interoprability||interoperability
+interuupt||interrupt
 interrface||interface
 interrrupt||interrupt
 interrup||interrupt
@@ -638,8 +658,10 @@ intrrupt||interrupt
 intterrupt||interrupt
 intuative||intuitive
 invaid||invalid
+invald||invalid
 invalde||invalid
 invalide||invalid
+invalidiate||invalidate
 invalud||invalid
 invididual||individual
 invokation||invocation
@@ -713,6 +735,7 @@ misformed||malformed
 mispelled||misspelled
 mispelt||misspelt
 mising||missing
+mismactch||mismatch
 missmanaged||mismanaged
 missmatch||mismatch
 miximum||maximum
@@ -731,6 +754,7 @@ multidimensionnal||multidimensional
 multple||multiple
 mumber||number
 muticast||multicast
+mutilcast||multicast
 mutiple||multiple
 mutli||multi
 nams||names
@@ -834,6 +858,7 @@ posible||possible
 positon||position
 possibilites||possibilities
 powerfull||powerful
+preample||preamble
 preapre||prepare
 preceeded||preceded
 preceeding||preceding
@@ -1059,6 +1084,7 @@ sturcture||structure
 subdirectoires||subdirectories
 suble||subtle
 substract||subtract
+submition||submission
 succesfully||successfully
 succesful||successful
 successed||succeeded
@@ -1078,6 +1104,7 @@ suppoted||supported
 suppported||supported
 suppport||support
 supress||suppress
+surpressed||suppressed
 surpresses||suppresses
 susbsystem||subsystem
 suspeneded||suspended
@@ -1091,6 +1118,7 @@ swithced||switched
 swithcing||switching
 swithed||switched
 swithing||switching
+swtich||switch
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
@@ -1111,7 +1139,9 @@ therfore||therefore
 thier||their
 threds||threads
 threshhold||threshold
+thresold||threshold
 throught||through
+troughput||throughput
 thses||these
 tiggered||triggered
 tipically||typically
@@ -1120,6 +1150,7 @@ tmis||this
 torerable||tolerable
 tramsmitted||transmitted
 tramsmit||transmit
+tranasction||transaction
 tranfer||transfer
 transciever||transceiver
 transferd||transferred
@@ -1133,6 +1164,7 @@ trasmission||transmission
 treshold||threshold
 trigerring||triggering
 trun||turn
+tunning||tuning
 ture||true
 tyep||type
 udpate||update
@@ -1199,6 +1231,7 @@ visiters||visitors
 vitual||virtual
 wakeus||wakeups
 wating||waiting
+wiat||wait
 wether||whether
 whataver||whatever
 whcih||which
_

Patches currently in -mm which might be from colin.king@canonical.com are


