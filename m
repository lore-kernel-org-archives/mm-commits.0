Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC2CC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5AF92229C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 18:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgLWS1f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:27:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgLWS1f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 13:27:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C2722286;
        Wed, 23 Dec 2020 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608748014;
        bh=lIWFH1pc2eaY7zGxuMwipEFRj3EsiYsbxILgo3PSVkw=;
        h=Date:From:To:Subject:From;
        b=0TXDcpcaZajNkAvlRSAMMsH1SgYRvgcnlNpAk6gNPSuL2UJ8fTbX39qa3En/b4FNf
         cIbuYDXm2Y8xhd3Onq1gnyIK87AwMIbLuvOTJikjmmiUq6Dh6iMBSoT1LjGsQnW5J5
         nB4prEy3eKZZznBXJ5BplZRUgAh8Uass1lgpPb8I=
Date:   Wed, 23 Dec 2020 10:26:54 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20201223182654.sRrhzbsVe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kasan.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/dev-tools/kasan.rst~linux-next-rejects
+++ a/Documentation/dev-tools/kasan.rst
@@ -21,8 +21,8 @@ out-of-bounds accesses for global variab
 
 Tag-based KASAN is only supported in Clang.
 
-Currently generic KASAN is supported for the x86_64, arm64, xtensa, s390 and
-and riscv architectures, and tag-based KASAN modes are supported only for arm64.
+Currently generic KASAN is supported for the x86_64, arm, arm64, xtensa, s390
+and riscv architectures, and tag-based KASAN is supported only for arm64.
 
 Usage
 -----
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-prototype-for-__add_to_page_cache_locked-fix.patch
mm.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
proc-wchan-use-printk-format-instead-of-lookup_symbol_name-fix.patch
kmap-stupid-hacks-to-make-it-compile.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

