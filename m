Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B47AC2BA19
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A9264F23
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 17:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCOR4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232051AbhCORsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 13:48:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4C6664E31;
        Mon, 15 Mar 2021 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615830447;
        bh=XBJD2iLBi3s0O/o+ZZa3it/jsd9/XGfiEoqYC5jg5iU=;
        h=Date:From:To:Subject:From;
        b=E2ueqsrkhUFCisKg/B46zQ8xbrdBilvdGlcul6qwPKnhAa4KmonlyCSKJdDvWytW7
         zj0Shtg6SlmqSDtfbqgheDuuDsrmxHanvQ3B5QFJwkN5TSVRu0B8RYg3b9Xx/n6cN5
         Tdhy4W5skJqG67UJ6nmbzzUo8+W0qNez+YnFCK/Y=
Date:   Mon, 15 Mar 2021 10:47:26 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20210315174726.BYs3zvDX6%akpm@linux-foundation.org>
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

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~linux-next-rejects
+++ a/mm/memory_hotplug.c
@@ -1133,7 +1133,7 @@ bool mhp_supports_memmap_on_memory(unsig
  */
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
-	struct mhp_params params = { .pgprot = PAGE_KERNEL };
+	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	struct vmem_altmap mhp_altmap = {};
 	u64 start, size;
 	bool new_node = false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

