Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D617FC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 21:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiKHVYY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 16:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKHVYY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:24:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE921B9C9
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F3E561761
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ADBC433D6;
        Tue,  8 Nov 2022 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667942662;
        bh=Hbgb4ChfVxS4uB8LzIy63eRhblkpIupOlLXXasxgnig=;
        h=Date:To:From:Subject:From;
        b=AY/AY+y9vhTkYRBCU//Z4G0Cart6XXbvw480mk7jd0Zdo3LO60AEvUhHBOrl2JXvW
         aU0T6zT+2oI8is7JY4poTpRhTp8eyBrZC8sRr1WxU9NYmJKgSearx9BsovLY+F+pUj
         Cpk7tnbXxdz/XtHu7WLjkSE5E22HhPYvwbkYoEOA=
Date:   Tue, 08 Nov 2022 13:24:21 -0800
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to mm-nonmm-unstable branch
Message-Id: <20221108212422.05ADBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt
Date: Tue, 8 Nov 2022 11:07:12 +0000

Some of the more common spelling mistakes and typos that I've found while
fixing up spelling mistakes in the kernel in the past year.

Link: https://lkml.kernel.org/r/20221108110712.114611-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -23,6 +23,7 @@ absoulte||absolute
 acccess||access
 acceess||access
 accelaration||acceleration
+accelearion||acceleration
 acceleratoin||acceleration
 accelleration||acceleration
 accesing||accessing
@@ -58,6 +59,7 @@ acording||according
 activete||activate
 actived||activated
 actualy||actually
+actvie||active
 acumulating||accumulating
 acumulative||accumulative
 acumulator||accumulator
@@ -253,6 +255,7 @@ brigde||bridge
 broadcase||broadcast
 broadcat||broadcast
 bufer||buffer
+bufferred||buffered
 bufufer||buffer
 cacluated||calculated
 caculate||calculate
@@ -273,6 +276,7 @@ cant||can't
 cant'||can't
 canot||cannot
 cann't||can't
+cannnot||cannot
 capabilites||capabilities
 capabilties||capabilities
 capabilty||capability
@@ -309,6 +313,7 @@ chiled||child
 chked||checked
 chnage||change
 chnages||changes
+chnange||change
 chnnel||channel
 choosen||chosen
 chouse||chose
@@ -439,6 +444,7 @@ defferred||deferred
 definate||definite
 definately||definitely
 definiation||definition
+definiton||definition
 defintion||definition
 defintions||definitions
 defualt||default
@@ -452,6 +458,7 @@ delare||declare
 delares||declares
 delaring||declaring
 delemiter||delimiter
+delibrately||deliberately
 delievered||delivered
 demodualtor||demodulator
 demension||dimension
@@ -481,6 +488,7 @@ destroied||destroyed
 detabase||database
 deteced||detected
 detectt||detect
+detroyed||destroyed
 develope||develop
 developement||development
 developped||developed
@@ -507,6 +515,7 @@ dimention||dimension
 dimesions||dimensions
 diconnected||disconnected
 disabed||disabled
+disasembler||disassembler
 disble||disable
 disgest||digest
 disired||desired
@@ -666,6 +675,7 @@ finanize||finalize
 findn||find
 finilizes||finalizes
 finsih||finish
+fliter||filter
 flusing||flushing
 folloing||following
 followign||following
@@ -725,6 +735,7 @@ hanled||handled
 happend||happened
 hardare||hardware
 harware||hardware
+hardward||hardware
 havind||having
 heirarchically||hierarchically
 heirarchy||hierarchy
@@ -740,6 +751,7 @@ howver||however
 hsould||should
 hypervior||hypervisor
 hypter||hyper
+idel||idle
 identidier||identifier
 iligal||illegal
 illigal||illegal
@@ -931,9 +943,11 @@ matchs||matches
 mathimatical||mathematical
 mathimatic||mathematic
 mathimatics||mathematics
+maxmium||maximum
 maximium||maximum
 maxium||maximum
 mechamism||mechanism
+mechanim||mechanism
 meetign||meeting
 memeory||memory
 memmber||member
@@ -942,6 +956,7 @@ memroy||memory
 ment||meant
 mergable||mergeable
 mesage||message
+mesages||messages
 messags||messages
 messgaes||messages
 messsage||message
@@ -983,8 +998,9 @@ monochromo||monochrome
 monocrome||monochrome
 mopdule||module
 mroe||more
-multipler||multiplier
 mulitplied||multiplied
+muliple||multiple
+multipler||multiplier
 multidimensionnal||multidimensional
 multipe||multiple
 multple||multiple
@@ -1109,6 +1125,7 @@ peroid||period
 persistance||persistence
 persistant||persistent
 phoneticly||phonetically
+plaform||platform
 plalform||platform
 platfoem||platform
 platfrom||platform
@@ -1236,6 +1253,7 @@ refering||referring
 refernces||references
 refernnce||reference
 refrence||reference
+regiser||register
 registed||registered
 registerd||registered
 registeration||registration
@@ -1276,6 +1294,7 @@ reseting||resetting
 reseved||reserved
 reseverd||reserved
 resizeable||resizable
+resotre||restore
 resouce||resource
 resouces||resources
 resoures||resources
@@ -1314,6 +1333,7 @@ runtine||runtime
 sacrifying||sacrificing
 safly||safely
 safty||safety
+satify||satisfy
 savable||saveable
 scaleing||scaling
 scaned||scanned
@@ -1365,10 +1385,12 @@ similiar||similar
 simlar||similar
 simliar||similar
 simpified||simplified
+simultaneusly||simultaneously
 simultanous||simultaneous
 singaled||signaled
 singal||signal
 singed||signed
+slect||select
 sleeped||slept
 sliped||slipped
 softwade||software
@@ -1438,6 +1460,7 @@ suported||supported
 suport||support
 supportet||supported
 suppored||supported
+supporing||supporting
 supportin||supporting
 suppoted||supported
 suppported||supported
@@ -1475,15 +1498,18 @@ sytem||system
 sythesis||synthesis
 taht||that
 tained||tainted
+tarffic||traffic
 tansmit||transmit
 targetted||targeted
 targetting||targeting
 taskelt||tasklet
 teh||the
+temeprature||temperature
 temorary||temporary
 temproarily||temporarily
 temperture||temperature
 thead||thread
+theads||threads
 therfore||therefore
 thier||their
 threds||threads
@@ -1533,12 +1559,14 @@ ture||true
 tyep||type
 udpate||update
 uesd||used
+unknwon||unknown
 uknown||unknown
 usccess||success
 uncommited||uncommitted
 uncompatible||incompatible
 unconditionaly||unconditionally
 undeflow||underflow
+undelying||underlying
 underun||underrun
 unecessary||unnecessary
 unexecpted||unexpected
@@ -1569,11 +1597,14 @@ unneedingly||unnecessarily
 unnsupported||unsupported
 unmached||unmatched
 unprecise||imprecise
+unpriviledged||unprivileged
+unpriviliged||unprivileged
 unregester||unregister
 unresgister||unregister
 unrgesiter||unregister
 unsinged||unsigned
 unstabel||unstable
+unsolicted||unsolicited
 unsolicitied||unsolicited
 unsuccessfull||unsuccessful
 unsuported||unsupported
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

lib-remove-redundant-assignment-to-variable-num.patch
scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

