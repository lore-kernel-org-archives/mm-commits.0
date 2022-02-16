Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C77BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 20:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiBPUhU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Feb 2022 15:37:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiBPUhT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Feb 2022 15:37:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990551A76E4
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 12:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED7D61A73
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 20:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F51C004E1;
        Wed, 16 Feb 2022 20:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645043825;
        bh=HFsam9hLO4NaC88i4UHGl9N/PTdajFXNik19WTe6lGg=;
        h=Date:To:From:Subject:From;
        b=Wk2mMB0InasusPRo4kn9/65fEZdky4832KRmM2SY6HcXGoWrT1RqJ2a3KLK9r+86n
         7y4G/KBqM0o48yNzW7+J6E9a5If9ZF6BgBNBO0Aj+PHgatVkyTj0YVNtzf2Iwcfolq
         Zg2dMS1vE//Xlwm2N292SD5SYK5ajM0hKil7fHR8=
Date:   Wed, 16 Feb 2022 12:37:05 -0800
To:     mm-commits@vger.kernel.org, joe@perches.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to -mm tree
Message-Id: <20220216203705.91F51C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt

Some of the more common spelling mistakes and typos that I've found
while fixing up spelling mistakes in the kernel in the past four months.

Link: https://lkml.kernel.org/r/20220216152343.105546-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -180,6 +180,7 @@ asuming||assuming
 asycronous||asynchronous
 asychronous||asynchronous
 asynchnous||asynchronous
+asynchronus||asynchronous
 asynchromous||asynchronous
 asymetric||asymmetric
 asymmeric||asymmetric
@@ -231,6 +232,7 @@ baloons||balloons
 bandwith||bandwidth
 banlance||balance
 batery||battery
+battey||battery
 beacuse||because
 becasue||because
 becomming||becoming
@@ -333,6 +335,7 @@ commoditiy||commodity
 comsume||consume
 comsumer||consumer
 comsuming||consuming
+comaptible||compatible
 compability||compatibility
 compaibility||compatibility
 comparsion||comparison
@@ -353,7 +356,9 @@ compoment||component
 comppatible||compatible
 compres||compress
 compresion||compression
+compresser||compressor
 comression||compression
+comsumed||consumed
 comunicate||communicate
 comunication||communication
 conbination||combination
@@ -530,6 +535,7 @@ dissconect||disconnect
 distiction||distinction
 divisable||divisible
 divsiors||divisors
+dsiabled||disabled
 docuentation||documentation
 documantation||documentation
 documentaion||documentation
@@ -677,6 +683,7 @@ frequence||frequency
 frequncy||frequency
 frequancy||frequency
 frome||from
+fronend||frontend
 fucntion||function
 fuction||function
 fuctions||functions
@@ -761,6 +768,7 @@ implmentation||implementation
 implmenting||implementing
 incative||inactive
 incomming||incoming
+incompaitiblity||incompatibility
 incompatabilities||incompatibilities
 incompatable||incompatible
 incompatble||incompatible
@@ -942,6 +950,7 @@ metdata||metadata
 micropone||microphone
 microprocesspr||microprocessor
 migrateable||migratable
+millenium||millennium
 milliseonds||milliseconds
 minium||minimum
 minimam||minimum
@@ -1007,6 +1016,7 @@ notity||notify
 nubmer||number
 numebr||number
 numner||number
+nunber||number
 obtaion||obtain
 obusing||abusing
 occassionally||occasionally
@@ -1136,6 +1146,7 @@ preprare||prepare
 pressre||pressure
 presuambly||presumably
 previosuly||previously
+previsously||previously
 primative||primitive
 princliple||principle
 priorty||priority
@@ -1297,6 +1308,7 @@ routins||routines
 rquest||request
 runing||running
 runned||ran
+runnnig||running
 runnning||running
 runtine||runtime
 sacrifying||sacrificing
@@ -1353,6 +1365,7 @@ similiar||similar
 simlar||similar
 simliar||similar
 simpified||simplified
+simultanous||simultaneous
 singaled||signaled
 singal||signal
 singed||signed
@@ -1461,6 +1474,7 @@ syste||system
 sytem||system
 sythesis||synthesis
 taht||that
+tained||tainted
 tansmit||transmit
 targetted||targeted
 targetting||targeting
@@ -1489,6 +1503,7 @@ timout||timeout
 tmis||this
 toogle||toggle
 torerable||tolerable
+torlence||tolerance
 traget||target
 traking||tracking
 tramsmitted||transmitted
@@ -1503,6 +1518,7 @@ transferd||transferred
 transfered||transferred
 transfering||transferring
 transision||transition
+transistioned||transitioned
 transmittd||transmitted
 transormed||transformed
 trasfer||transfer
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
remove-bdi_congested-and-wb_congested-and-related-functions-fix-2.patch

