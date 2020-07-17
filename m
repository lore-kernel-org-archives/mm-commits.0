Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7688BC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 00:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5542B207BC
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 00:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594944076;
	bh=BBNXYE94PSJ+QhzQsKy6ZEmhhAnVtHw6fbkeFuwi8jI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=hf/G4EpBQz3GMyOhDrUC2w4gaG4LybcKlBMl6a7bqYCtad8cODhGnfU079TPQWzfR
	 0ymA2NGwr++ryEOtiFZ9vOyB7ISepOyC2O15VByrYfIUjaKGvbh4GxTpnJHmic4iZj
	 KhFAPlOhAXHnR8cLp6heZxfeEfDG4E18JjEudJ6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgGQABQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 20:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgGQABP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 20:01:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B72206F4;
        Fri, 17 Jul 2020 00:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594944074;
        bh=BBNXYE94PSJ+QhzQsKy6ZEmhhAnVtHw6fbkeFuwi8jI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HT+ZOptn5xyvmzJsCHceUDXwKxELpf5mx65V/VV3brzwXMeENjOcWM5QKIpGzjeXe
         dB9DrZlOQQ/KRaTIhvvQiPoxv4NnFzNIha3JnSkngY/juOgsmLvyLCwlwUTB+V34On
         DhmytGeiAjJy+TAYA/8f0isaGlVo9Jz0dsiCgs7w=
Date:   Thu, 16 Jul 2020 17:01:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  +
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to -mm
 tree
Message-ID: <20200717000114.E0z-MXFAN%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt

Here are some of the more common spelling mistakes and typos that I've
found while fixing up spelling mistakes in the kernel since April 2020.

Link: http://lkml.kernel.org/r/20200714092837.173796-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -149,6 +149,7 @@ arbitary||arbitrary
 architechture||architecture
 arguement||argument
 arguements||arguments
+arithmatic||arithmetic
 aritmetic||arithmetic
 arne't||aren't
 arraival||arrival
@@ -454,6 +455,7 @@ destorys||destroys
 destroied||destroyed
 detabase||database
 deteced||detected
+detectt||detect
 develope||develop
 developement||development
 developped||developed
@@ -545,6 +547,7 @@ entires||entries
 entites||entities
 entrys||entries
 enocded||encoded
+enought||enough
 enterily||entirely
 enviroiment||environment
 enviroment||environment
@@ -556,11 +559,14 @@ equivelant||equivalent
 equivilant||equivalent
 eror||error
 errorr||error
+errror||error
 estbalishment||establishment
 etsablishment||establishment
 etsbalishment||establishment
+evalution||evaluation
 excecutable||executable
 exceded||exceeded
+exceds||exceeds
 exceeed||exceed
 excellant||excellent
 execeeded||exceeded
@@ -583,6 +589,7 @@ explictly||explicitly
 expresion||expression
 exprimental||experimental
 extened||extended
+exteneded||extended||extended
 extensability||extensibility
 extention||extension
 extenstion||extension
@@ -610,10 +617,12 @@ feautures||features
 fetaure||feature
 fetaures||features
 fileystem||filesystem
+fimrware||firmware
 fimware||firmware
 firmare||firmware
 firmaware||firmware
 firware||firmware
+firwmare||firmware
 finanize||finalize
 findn||find
 finilizes||finalizes
@@ -661,6 +670,7 @@ globel||global
 grabing||grabbing
 grahical||graphical
 grahpical||graphical
+granularty||granularity
 grapic||graphic
 grranted||granted
 guage||gauge
@@ -906,6 +916,7 @@ miximum||maximum
 mmnemonic||mnemonic
 mnay||many
 modfiy||modify
+modifer||modifier
 modulues||modules
 momery||memory
 memomry||memory
@@ -915,6 +926,7 @@ monochromo||monochrome
 monocrome||monochrome
 mopdule||module
 mroe||more
+multipler||multiplier
 mulitplied||multiplied
 multidimensionnal||multidimensional
 multipe||multiple
@@ -952,6 +964,7 @@ occassionally||occasionally
 occationally||occasionally
 occurance||occurrence
 occurances||occurrences
+occurd||occurred
 occured||occurred
 occurence||occurrence
 occure||occurred
@@ -1058,6 +1071,7 @@ precission||precision
 preemptable||preemptible
 prefered||preferred
 prefferably||preferably
+prefitler||prefilter
 premption||preemption
 prepaired||prepared
 preperation||preparation
@@ -1101,6 +1115,7 @@ pronunce||pronounce
 propery||property
 propigate||propagate
 propigation||propagation
+propogation||propagation
 propogate||propagate
 prosess||process
 protable||portable
@@ -1316,6 +1331,7 @@ sturcture||structure
 subdirectoires||subdirectories
 suble||subtle
 substract||subtract
+submited||submitted
 submition||submission
 suceed||succeed
 succesfully||successfully
@@ -1324,6 +1340,7 @@ successed||succeeded
 successfull||successful
 successfuly||successfully
 sucessfully||successfully
+sucessful||successful
 sucess||success
 superflous||superfluous
 superseeded||superseded
@@ -1409,6 +1426,7 @@ transormed||transformed
 trasfer||transfer
 trasmission||transmission
 treshold||threshold
+triggerd||triggered
 trigerred||triggered
 trigerring||triggering
 trun||turn
@@ -1421,6 +1439,7 @@ uknown||unknown
 usccess||success
 usupported||unsupported
 uncommited||uncommitted
+uncompatible||incompatible
 unconditionaly||unconditionally
 undeflow||underflow
 underun||underrun
_

Patches currently in -mm which might be from colin.king@canonical.com are

scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch
fs-ufs-avoid-potential-u32-multiplication-overflow.patch

