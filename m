Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4F9C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbjHKXBq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjHKXA1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBDD3A86
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3535267B38
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3F3C433C9;
        Fri, 11 Aug 2023 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794803;
        bh=gAR1Csf8krl0Q8AweESSk71LYHevLH7acPxltUzoEJc=;
        h=Date:To:From:Subject:From;
        b=fg9NVLaHSdUDDIduOOxMP78EVFyuPATnG9ASeFYMZGUnOas96XZlFcF8I/r8n9AC0
         RF6ZAjByyd6VDWW+QTutkjJcBy9zGMSTTGUCxr3Q/HpPCkC0inMqpR176PP1DbmnLx
         TET8Ih8TNfjzKcZ5yjEumfurg8hMWG9c7rHdbAVM=
Date:   Fri, 11 Aug 2023 16:00:03 -0700
To:     mm-commits@vger.kernel.org, andi@firstfloor.org,
        ak@linux.intel.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hwpoison-offline-support-fix-spelling-in-documentation-abi.patch removed from -mm tree
Message-Id: <20230811230003.8D3F3C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: HWPOISON: offline support: fix spelling in Documentation/ABI/
has been removed from the -mm tree.  Its filename was
     hwpoison-offline-support-fix-spelling-in-documentation-abi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: HWPOISON: offline support: fix spelling in Documentation/ABI/
Date: Sun, 9 Jul 2023 22:22:23 -0700

Correct spelling problems as identified by codespell.

Link: https://lkml.kernel.org/r/20230710052223.18254-1-rdunlap@infradead.org
Fixes: facb6011f399 ("HWPOISON: Add soft page offline support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-memory-page-offline |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-memory-page-offline~hwpoison-offline-support-fix-spelling-in-documentation-abi
+++ a/Documentation/ABI/testing/sysfs-memory-page-offline
@@ -10,7 +10,7 @@ Description:
 		dropping it if possible. The kernel will then be placed
 		on the bad page list and never be reused.
 
-		The offlining is done in kernel specific granuality.
+		The offlining is done in kernel specific granularity.
 		Normally it's the base page size of the kernel, but
 		this might change.
 
@@ -35,7 +35,7 @@ Description:
 		to access this page assuming it's poisoned by the
 		hardware.
 
-		The offlining is done in kernel specific granuality.
+		The offlining is done in kernel specific granularity.
 		Normally it's the base page size of the kernel, but
 		this might change.
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are


