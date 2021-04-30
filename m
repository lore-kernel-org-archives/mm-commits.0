Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9912C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C145061434
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3FVM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3FVM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:21:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2079B6121E;
        Fri, 30 Apr 2021 05:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760024;
        bh=vSuIUMpz9hKIV70bqKoTSTPXOApQsANyJauEY3bC+C8=;
        h=Date:From:To:Subject:From;
        b=RBP/APBVknNTvYBJuJNLu6RN2t1B5kzKlMo6yYiCOMlLKY0wIG5m8QFA+5aajrP9h
         GeH8cStNmQu6mEpdvyQ7qEJfEpvY++trbz75oKiItCMoOJtUJBXWHaHpLxUXNE/z44
         yC0ZKJBAjmFT4X0HRQUbyQ2Pf/1o5Fj7Lxb340jI=
Date:   Thu, 29 Apr 2021 22:20:23 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, joe@perches.com, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, wanjiabing@vivo.com
Subject:  [folded-merged]
 scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
 removed from -mm tree
Message-ID: <20210430052023.7PSo5QUMs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-a-new-script-for-checking-duplicate-struct-declaration-fix
has been removed from the -mm tree.  Its filename was
     scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch

This patch was dropped because it was folded into scripts-a-new-script-for-checking-duplicate-struct-declaration.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-a-new-script-for-checking-duplicate-struct-declaration-fix

fix usage message, grammar

Cc: Joe Perches <joe@perches.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkdeclares.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkdeclares.pl~scripts-a-new-script-for-checking-duplicate-struct-declaration-fix
+++ a/scripts/checkdeclares.pl
@@ -15,8 +15,8 @@
 use strict;
 
 sub usage {
-	print "Usage: checkdeclares.pl \n";
-	print "We just warn of struct declaration duplicates\n";
+	print "Usage: checkdeclares.pl file1.h ...\n";
+	print "Warns of struct declaration duplicates\n";
 	exit 1;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

