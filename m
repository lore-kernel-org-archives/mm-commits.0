Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1FBC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:52:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28EE12074B
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594943554;
	bh=wFuLBI8DEbxTSI3k86OkBdnqCceQCi2dlfQlJee1NHI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dmvl+5+JWzRAEhC2jLVgfPWpn2wVm8RyC0hQQuxBxgTqTRzyrVzQWq7kKBT32evh8
	 Sks+zC6iohYjk1pf7W15hvPWsnGgPd6KwPUwgPvw4jAwlF3li4rrtkn/2Naj6kM00j
	 zZ9HdLKxirPslKQ9rG8Taby8VW0UIBdRAYSIbC08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgGPXwd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgGPXwd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:52:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7765206F4;
        Thu, 16 Jul 2020 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594943552;
        bh=wFuLBI8DEbxTSI3k86OkBdnqCceQCi2dlfQlJee1NHI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=nxo5CwMbWS1Ut7whR7gxWSfyCSQ4ZKCHa5lgmW5Y/sfw/qd6dG5LVCIckgznu+9Hw
         GQgbbrF7TsOGze9QqaVWmKV5NHN+ikcXryhXI7aVjzIWBeFPdoyzDs1puxA0anFLER
         U1XNgnLSzMXW6V/5r6RucM6vZXWQ054ovddRQ8XI=
Date:   Thu, 16 Jul 2020 16:52:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, grandmaster@al2klimov.de,
        mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  + mm-thp-replace-http-links-with-https-ones-fix.patch
 added to -mm tree
Message-ID: <20200716235231.8s8M2lDLf%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-replace-http-links-with-https-ones-fix
has been added to the -mm tree.  Its filename is
     mm-thp-replace-http-links-with-https-ones-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-replace-http-links-with-https-ones-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-replace-http-links-with-https-ones-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-replace-http-links-with-https-ones-fix

fix amd.com URL, per Vlastimil

Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-replace-http-links-with-https-ones-fix
+++ a/mm/huge_memory.c
@@ -2065,8 +2065,8 @@ static void __split_huge_pmd_locked(stru
 	 * free), userland could trigger a small page size TLB miss on the
 	 * small sized TLB while the hugepage TLB entry is still established in
 	 * the huge TLB. Some CPU doesn't like that.
-	 * See https://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum
-	 * 383 on page 93. Intel should be safe but is also warns that it's
+	 * See http://support.amd.com/TechDocs/41322_10h_Rev_Gd.pdf, Erratum
+	 * 383 on page 105. Intel should be safe but is also warns that it's
 	 * only safe if the permission and cache attributes of the two entries
 	 * loaded in the two TLB is identical (which should be the case here).
 	 * But it is generally safer to never allow small and huge TLB entries
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
revert-squashfs-migrate-from-ll_rw_block-usage-to-bio.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

