Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9908FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357311AbiCYBbN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243739AbiCYBbM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D923237DA
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 045E561923
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546D9C340EC;
        Fri, 25 Mar 2022 01:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171778;
        bh=3zttCN8gLey5gkrIAEh3WwknuvDJGc+7WV3o+qRfrG8=;
        h=Date:To:From:Subject:From;
        b=fXnjh21maKgMNK7Y80QN/MXUm44WHvxpBDtaL1HVWmz1CnDU5u2UKo7RK26v1RuYQ
         W7cyACZXSaT5jzOhqxQM9+updWqSRq9j+p/boie26RDq3dpErcc0e7ibKayNoaYo46
         c/+u45pqR7VfFusCZofYdF0mpEiEX3sYjs6t1izQ=
Date:   Thu, 24 Mar 2022 18:29:37 -0700
To:     mm-commits@vger.kernel.org, joe@perches.com,
        colin.i.king@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from -mm tree
Message-Id: <20220325012938.546D9C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


