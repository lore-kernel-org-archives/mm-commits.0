Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83858C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6084E206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026858;
	bh=vPIu5AFqW1r/YMCfn25mdwvUEb/xy49FhMUaMhKshzA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SZHakqSbF9+p0SzDlxCkVYskJ5YFHXtoJF1MgW3yhcA5E70t3sk47bsWked9qJYFo
	 XgQwxDvNVEVhrpX+/p94UNmA1MZVhkwPp2a3Xzp7vjAwaipnmceVgKvcu2SUJV6gCC
	 vSJ+5cLbtC9zW48wZJ4DZ0Xr8z4N9o8uxyQdvbaY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHJCeS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCeR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59CA6206C3;
        Mon, 10 Aug 2020 02:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026857;
        bh=vPIu5AFqW1r/YMCfn25mdwvUEb/xy49FhMUaMhKshzA=;
        h=Date:From:To:Subject:From;
        b=YKYqCn8EMNbDRnDHJrH2BUS/PL0kFjFlj/BTsSsUfVvI1hUoKT2+0ljEJ4717FO30
         LodPO8hmyhMI86islrZ2bU/wZNhDFHE/e4XByu1WbJuF+BeyVY5xqL3XGYFPsePDfM
         o+cO4/RakcnOMCVIc0V7WBQnysDuY3Njgj6gk9eA=
Date:   Sun, 09 Aug 2020 19:34:17 -0700
From:   akpm@linux-foundation.org
To:     colin.king@canonical.com, mm-commits@vger.kernel.org
Subject:  [merged]
 scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from
 -mm tree
Message-ID: <20200810023417._5Alq6qhP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
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

fs-ufs-avoid-potential-u32-multiplication-overflow.patch

