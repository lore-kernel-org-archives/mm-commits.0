Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B95AC4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01ED220BED
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085846;
	bh=RdIGZ+rTEJeYIVTZIu2lhaDGyVa86L3+PGjco8S0PcU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BfNnzELulOVbfsx6eLpQXpv+gf3fmuVYfK3KMLBP0umcSERs+KhZ2TDkSEKZgwUVO
	 h6rZlU0JHf2SW7IH4X8m9EsMK9NgF3bWpfosi37mWZ8tNo4ZkA0DRnDW69k1s4ti3d
	 Zfy+WYQBcjBlI7Jm5VzX0DRUWIeG9lBEA0M3no2U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgIZCEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgIZCEF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:04:05 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C09F32087D;
        Sat, 26 Sep 2020 02:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085845;
        bh=RdIGZ+rTEJeYIVTZIu2lhaDGyVa86L3+PGjco8S0PcU=;
        h=Date:From:To:Subject:From;
        b=LVSV9apvRUQLZfjQi4sPmVZnSSkpn9xJskXzH+H2T/UjFGv+Xh2FER/MLjDxQj9sL
         8sIG7KDGZycRNAcSgkeeReqZedxLnLA6ook9LarMIUvlONNA4T1E9ccnsnuB8+WgFR
         bPJwp4aXmVwpb+B1WRi/sTlhzW+a/aIIRvOZTJQ4=
Date:   Fri, 25 Sep 2020 19:04:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, xndchn@gmail.com, sjpark@amazon.de,
        luca@lucaceresoli.net, joe@perches.com, j.neuschaefer@gmx.net,
        colin.king@canonical.com, wangqing@vivo.com
Subject:  + increase-error-prone-spell-checking.patch added to -mm
 tree
Message-ID: <20200926020404.yX9_2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: increase error-prone spell checking
has been added to the -mm tree.  Its filename is
     increase-error-prone-spell-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/increase-error-prone-spell-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/increase-error-prone-spell-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: scripts/spelling.txt: increase error-prone spell checking

Increase direcly,ununsed,manger spelling error check

Link: https://lkml.kernel.org/r/1601085397-27586-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Xiong <xndchn@gmail.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Neuschfer <j.neuschaefer@gmx.net>
Cc: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/spelling.txt~increase-error-prone-spell-checking
+++ a/scripts/spelling.txt
@@ -482,6 +482,7 @@ disgest||digest
 dispalying||displaying
 diplay||display
 directon||direction
+direcly||directly
 direectly||directly
 diregard||disregard
 disassocation||disassociation
@@ -871,6 +872,7 @@ malplace||misplace
 managable||manageable
 managment||management
 mangement||management
+manger||manager
 manoeuvering||maneuvering
 manufaucturing||manufacturing
 mappping||mapping
@@ -1478,6 +1480,7 @@ unsolicitied||unsolicited
 unsuccessfull||unsuccessful
 unsuported||unsupported
 untill||until
+ununsed||unused
 unuseful||useless
 unvalid||invalid
 upate||update
_

Patches currently in -mm which might be from wangqing@vivo.com are

increase-error-prone-spell-checking.patch

