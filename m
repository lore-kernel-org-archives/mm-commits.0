Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107B1EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 20:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjGJU2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 16:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjGJU2O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 16:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732A1198
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 13:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010C260C39
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 20:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB67C433C8;
        Mon, 10 Jul 2023 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689020892;
        bh=34cfpQexQ9MYhTEdVP0XAStn/l0XgBTdvPnhenqUFzc=;
        h=Date:To:From:Subject:From;
        b=IwgkHQbnVSJjQmx1q/QpDoABHMEqt2NhXIXNaAGXbr71nzCgOKJukzLZEJcK/1rCd
         MfymDRNYMGneuS1G/RZpzCzgOVIPL8dIcKqkACSiSwdxaIz4GHitkO+tZ2lEi4GdIV
         tbw7iMYHNC62Z3yB8PaIStOiL2Jl++7V6lrNFEzA=
Date:   Mon, 10 Jul 2023 13:28:11 -0700
To:     mm-commits@vger.kernel.org, andi@firstfloor.org,
        ak@linux.intel.com, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hwpoison-offline-support-fix-spelling-in-documentation-abi.patch added to mm-unstable branch
Message-Id: <20230710202812.4EB67C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: HWPOISON: offline support: fix spelling in Documentation/ABI/
has been added to the -mm mm-unstable branch.  Its filename is
     hwpoison-offline-support-fix-spelling-in-documentation-abi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hwpoison-offline-support-fix-spelling-in-documentation-abi.patch

This patch will later appear in the mm-unstable branch at
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

hwpoison-offline-support-fix-spelling-in-documentation-abi.patch

