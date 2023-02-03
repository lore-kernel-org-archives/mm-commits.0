Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC931C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjBCGwN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBCGv3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE238D40E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93502B8298B
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35110C433EF;
        Fri,  3 Feb 2023 06:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407075;
        bh=zNTtmSO68ei4L4C6jJwec1zwpcHPP93zy2B2OHwbpng=;
        h=Date:To:From:Subject:From;
        b=dsjrmWbirotsdCShrzOGtXbeIDHvEld4NzWB0DXREDN/8EFSiRWU0ATWZJZj14ypL
         RrZPQlUm6QZPXOtPaXfwhATd02cc1Jhz1BK03AtSE3swfXyUALZxUrbPAm5XYh70mb
         viNfRxmiT/Ufc8Zq6FDV4ejMf2UYM6xJJlQDTt+4=
Date:   Thu, 02 Feb 2023 22:51:14 -0800
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org,
        irogers@google.com, colin.i.king@gmail.com, didi.debian@cknow.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-more-spelling-corrections.patch removed from -mm tree
Message-Id: <20230203065115.35110C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/spelling.txt: add more spelling corrections
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spelling-corrections.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Diederik de Haas <didi.debian@cknow.org>
Subject: scripts/spelling.txt: add more spelling corrections
Date: Sun, 22 Jan 2023 18:32:56 +0100

Current Debian lintian tool flagged several (more) spelling errors, so
add them so they can hopefully be prevented in the future.

Link: https://lkml.kernel.org/r/20230122173256.52280-1-didi.debian@cknow.org
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-corrections
+++ a/scripts/spelling.txt
@@ -65,6 +65,7 @@ acumulative||accumulative
 acumulator||accumulator
 acutally||actually
 adapater||adapter
+adderted||asserted
 addional||additional
 additionaly||additionally
 additonal||additional
@@ -122,6 +123,7 @@ alue||value
 ambigious||ambiguous
 ambigous||ambiguous
 amoung||among
+amount of times||number of times
 amout||amount
 amplifer||amplifier
 amplifyer||amplifier
@@ -287,6 +289,7 @@ capapbilities||capabilities
 caputure||capture
 carefuly||carefully
 cariage||carriage
+casued||caused
 catagory||category
 cehck||check
 challange||challenge
@@ -370,6 +373,7 @@ conbination||combination
 conditionaly||conditionally
 conditon||condition
 condtion||condition
+condtional||conditional
 conected||connected
 conector||connector
 configration||configuration
@@ -423,6 +427,7 @@ cound||could
 couter||counter
 coutner||counter
 cryptocraphic||cryptographic
+cummulative||cumulative
 cunter||counter
 curently||currently
 cylic||cyclic
@@ -627,6 +632,7 @@ existant||existent
 exixt||exist
 exlcude||exclude
 exlcusive||exclusive
+exlusive||exclusive
 exmaple||example
 expecially||especially
 experies||expires
@@ -840,6 +846,7 @@ integrety||integrity
 integrey||integrity
 intendet||intended
 intented||intended
+interal||internal
 interanl||internal
 interchangable||interchangeable
 interferring||interfering
@@ -1025,6 +1032,7 @@ negotation||negotiation
 nerver||never
 nescessary||necessary
 nessessary||necessary
+none existent||non-existent
 noticable||noticeable
 notication||notification
 notications||notifications
@@ -1046,6 +1054,7 @@ occured||occurred
 occurence||occurrence
 occure||occurred
 occuring||occurring
+ocurrence||occurrence
 offser||offset
 offet||offset
 offlaod||offload
@@ -1057,6 +1066,7 @@ omitt||omit
 ommiting||omitting
 ommitted||omitted
 onself||oneself
+onthe||on the
 ony||only
 openning||opening
 operatione||operation
@@ -1337,6 +1347,7 @@ sacrifying||sacrificing
 safly||safely
 safty||safety
 satify||satisfy
+satisifed||satisfied
 savable||saveable
 scaleing||scaling
 scaned||scanned
@@ -1618,6 +1629,7 @@ unuseful||useless
 unvalid||invalid
 upate||update
 upsupported||unsupported
+upto||up to
 useable||usable
 usefule||useful
 usefull||useful
_

Patches currently in -mm which might be from didi.debian@cknow.org are


