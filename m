From: akpm@linux-foundation.org
Subject: [patch 002/102] scripts/spelling.txt: add several more
 common spelling mistakes
Date: Wed, 03 May 2017 14:51:32 -0700
Message-ID: <20170503215132.poFNW385q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47126 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVvd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:51:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, joe@perches.com, keescook@chromium.org, mm-commits@vger.kernel.org, sboyd@codeaurora.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add several more common spelling mistakes

Here are some of the more common spelling mistakes that I've found while
fixing up spelling mistakes in kernel error message text.  They probably
should be added to this list so we don't keep on seeing them appearing
again.

Link: http://lkml.kernel.org/r/20170421122534.5378-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Joe Perches <joe@perches.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-several-more-common-spelling-mistakes scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-several-more-common-spelling-mistakes
+++ a/scripts/spelling.txt
@@ -46,6 +46,8 @@ ackowledge||acknowledge
 ackowledged||acknowledged
 acording||according
 activete||activate
+actived||activated
+actualy||actually
 acumulating||accumulating
 acumulator||accumulator
 adapater||adapter
@@ -76,6 +78,8 @@ algorritm||algorithm
 aligment||alignment
 alignement||alignment
 allign||align
+alligned||aligned
+allocatote||allocate
 allocatrd||allocated
 allocte||allocate
 allpication||application
@@ -141,6 +145,7 @@ asycronous||asynchronous
 asynchnous||asynchronous
 atomatically||automatically
 atomicly||atomically
+atempt||attempt
 attachement||attachment
 attched||attached
 attemps||attempts
@@ -270,6 +275,7 @@ comunication||communication
 conbination||combination
 conditionaly||conditionally
 conected||connected
+connecetd||connected
 configuartion||configuration
 configuratoin||configuration
 configuraton||configuration
@@ -291,11 +297,14 @@ continous||continuous
 continously||continuously
 continueing||continuing
 contraints||constraints
+contol||control
+contoller||controller
 controled||controlled
 controler||controller
 controll||control
 contruction||construction
 contry||country
+conuntry||country
 convertion||conversion
 convertor||converter
 convienient||convenient
@@ -310,6 +319,7 @@ coutner||counter
 cryptocraphic||cryptographic
 cunter||counter
 curently||currently
+cylic||cyclic
 dafault||default
 deafult||default
 deamon||daemon
@@ -398,6 +408,7 @@ efective||effective
 efficently||efficiently
 ehther||ether
 eigth||eight
+elementry||elementary
 eletronic||electronic
 embeded||embedded
 enabledi||enabled
@@ -443,6 +454,7 @@ extened||extended
 extensability||extensibility
 extention||extension
 extracter||extractor
+falied||failed
 faild||failed
 faill||fail
 failied||failed
@@ -492,6 +504,7 @@ futhermore||furthermore
 futrue||future
 gaurenteed||guaranteed
 generiously||generously
+genereate||generate
 genric||generic
 globel||global
 grabing||grabbing
@@ -513,8 +526,10 @@ hierachy||hierarchy
 hierarchie||hierarchy
 howver||however
 hsould||should
+hypervior||hypervisor
 hypter||hyper
 identidier||identifier
+iligal||illegal
 illigal||illegal
 imblance||imbalance
 immeadiately||immediately
@@ -600,6 +615,7 @@ intuative||intuitive
 invaid||invalid
 invalde||invalid
 invalide||invalid
+invalud||invalid
 invididual||individual
 invokation||invocation
 invokations||invocations
@@ -663,11 +679,14 @@ messsages||messages
 microprocesspr||microprocessor
 milliseonds||milliseconds
 minium||minimum
+minimam||minimum
 minumum||minimum
+misalinged||misaligned
 miscelleneous||miscellaneous
 misformed||malformed
 mispelled||misspelled
 mispelt||misspelt
+mising||missing
 miximum||maximum
 mmnemonic||mnemonic
 mnay||many
@@ -888,6 +907,7 @@ replys||replies
 reponse||response
 representaion||representation
 reqeust||request
+requestied||requested
 requiere||require
 requirment||requirement
 requred||required
@@ -981,6 +1001,7 @@ spinlcok||spinlock
 spinock||spinlock
 splitted||split
 spreaded||spread
+spurrious||spurious
 sructure||structure
 stablilization||stabilization
 staically||statically
@@ -1013,6 +1034,7 @@ superseeded||superseded
 suplied||supplied
 suported||supported
 suport||support
+supportet||supported
 suppored||supported
 supportin||supporting
 suppoted||supported
@@ -1056,6 +1078,7 @@ throught||through
 thses||these
 tiggered||triggered
 tipically||typically
+timout||timeout
 tmis||this
 torerable||tolerable
 tramsmitted||transmitted
@@ -1081,6 +1104,7 @@ unconditionaly||unconditionally
 underun||underrun
 unecessary||unnecessary
 unexecpted||unexpected
+unexepected||unexpected
 unexpcted||unexpected
 unexpectd||unexpected
 unexpeted||unexpected
@@ -1096,6 +1120,7 @@ unneded||unneeded
 unneedingly||unnecessarily
 unnsupported||unsupported
 unmached||unmatched
+unregester||unregister
 unresgister||unregister
 unrgesiter||unregister
 unsinged||unsigned
_
