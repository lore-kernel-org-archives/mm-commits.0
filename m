Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C98BC61D97
	for <mm-commits@archiver.kernel.org>; Wed, 22 Nov 2023 21:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjKVVz3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbjKVVz1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Nov 2023 16:55:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EDE1A5
        for <mm-commits@vger.kernel.org>; Wed, 22 Nov 2023 13:55:23 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FC1C433C8;
        Wed, 22 Nov 2023 21:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700690123;
        bh=GkyO6gzwKTaS9B6wIQ4EiZni4I7o7Jx+dS6UeUej3GM=;
        h=Date:To:From:Subject:From;
        b=YrOcsa7fojgjOvB6o2HIuVL/3nQjM6kRO9vrxoPh89jvMhuS7ggAH06/kh5zzPUPy
         05WTsxnbb35P7pYSRIOsqrvuR/PNMtqLJzKiGfIOGWNWoZJyOpZsi5OzRTbROra3c/
         sxkEF2OlRBmSYjuFGA9K/g/nG/JXyt2uP/5qUOC8=
Date:   Wed, 22 Nov 2023 13:55:22 -0800
To:     mm-commits@vger.kernel.org, colin.i.king@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch added to mm-nonmm-unstable branch
Message-Id: <20231122215523.06FC1C433C8@smtp.kernel.org>
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
Date: Wed, 22 Nov 2023 10:40:37 +0000

Some of the more common spelling mistakes and typos that I've found while
fixing up spelling mistakes in the kernel over the past couple of
releases.

Link: https://lkml.kernel.org/r/20231122104037.1770749-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -26,6 +26,7 @@ accelaration||acceleration
 accelearion||acceleration
 acceleratoin||acceleration
 accelleration||acceleration
+accelrometer||accelerometer
 accesing||accessing
 accesnt||accent
 accessable||accessible
@@ -137,6 +138,7 @@ anniversery||anniversary
 annoucement||announcement
 anomolies||anomalies
 anomoly||anomaly
+anonynous||anonymous
 anway||anyway
 aplication||application
 appearence||appearance
@@ -267,6 +269,7 @@ cadidate||candidate
 cahces||caches
 calender||calendar
 calescing||coalescing
+calibraiton||calibration
 calle||called
 callibration||calibration
 callled||called
@@ -288,6 +291,7 @@ capabitilies||capabilities
 capablity||capability
 capatibilities||capabilities
 capapbilities||capabilities
+captuer||capture
 caputure||capture
 carefuly||carefully
 cariage||carriage
@@ -340,6 +344,7 @@ comminucation||communication
 commited||committed
 commiting||committing
 committ||commit
+commmand||command
 commnunication||communication
 commoditiy||commodity
 comsume||consume
@@ -406,6 +411,7 @@ continious||continuous
 continous||continuous
 continously||continuously
 continueing||continuing
+contiuous||continuous
 contraints||constraints
 contruct||construct
 contol||control
@@ -757,6 +763,7 @@ hardward||hardware
 havind||having
 heirarchically||hierarchically
 heirarchy||hierarchy
+heirachy||hierarchy
 helpfull||helpful
 hearbeat||heartbeat
 heterogenous||heterogeneous
@@ -1199,6 +1206,7 @@ priting||printing
 privilaged||privileged
 privilage||privilege
 priviledge||privilege
+priviledged||privileged
 priviledges||privileges
 privleges||privileges
 probaly||probably
@@ -1251,6 +1259,7 @@ purgable||purgeable
 pwoer||power
 queing||queuing
 quering||querying
+querrying||querying
 queus||queues
 randomally||randomly
 raoming||roaming
@@ -1324,6 +1333,7 @@ reseting||resetting
 reseved||reserved
 reseverd||reserved
 resizeable||resizable
+resonable||reasonable
 resotre||restore
 resouce||resource
 resouces||resources
@@ -1427,6 +1437,7 @@ sliped||slipped
 softwade||software
 softwares||software
 soley||solely
+soluation||solution
 souce||source
 speach||speech
 specfic||specific
@@ -1458,6 +1469,7 @@ standart||standard
 standy||standby
 stardard||standard
 staticly||statically
+statisitcs||statistics
 statuss||status
 stoped||stopped
 stoping||stopping
@@ -1548,6 +1560,7 @@ threds||threads
 threee||three
 threshhold||threshold
 thresold||threshold
+throtting||throttling
 throught||through
 tansition||transition
 trackling||tracking
@@ -1571,6 +1584,7 @@ tranasction||transaction
 tranceiver||transceiver
 tranfer||transfer
 tranmission||transmission
+tranport||transport
 transcevier||transceiver
 transciever||transceiver
 transferd||transferred
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

selftests-mm-check-that-pagemap_scan-returns-correct-categories-fix-2.patch
scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

