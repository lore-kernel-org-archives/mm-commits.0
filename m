Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7312C433F1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8556206E3
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633917;
	bh=o46IDBTB+1kCR1FecIk+SJTBdit23i/o5BbolVqT368=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hmjJ7mvljLKiTBBGW/UH/8HiHg/sLNpjDys2Pnm5ngg+53QXp7UNq9D5vakCJMKQP
	 kozOgIZF0xiBW7mKpMMzWur22ObNvJf1SH8LtqMgpjeHMTobNcF67yfB3JDuh9Ho9X
	 xMKln183RytKqNqxsno9eVvydM3pyWyyouDpIskw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgGXXih (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXih (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:37 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AEEA20737;
        Fri, 24 Jul 2020 23:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633916;
        bh=o46IDBTB+1kCR1FecIk+SJTBdit23i/o5BbolVqT368=;
        h=Date:From:To:Subject:From;
        b=g2PR4nNKezTesFqdxBcsR1S4xEu+zm9YGkd8fUsNkVfl7XdV+WXcmaop1nSltz5e4
         uISfDHMSmLJAEIwcDQHjBSwT02uh0lp38rRNOmzTAYjxBpYAssgAyz713FGh5lULJp
         q+lv4V1BJgjukV0k7zEbOsq42P7GSmdSH7rXVRRI=
Date:   Fri, 24 Jul 2020 16:38:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged] mailmap-add-entry-for-mike-rapoport.patch
 removed from -mm tree
Message-ID: <20200724233836.xdpKOdqTg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Mike Rapoport
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-mike-rapoport.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Mike Rapoport <rppt@linux.ibm.com>
Subject: mailmap: add entry for Mike Rapoport

Add an entry to correct my email addresses.

Link: http://lkml.kernel.org/r/20200708095414.12275-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-mike-rapoport
+++ a/.mailmap
@@ -198,6 +198,9 @@ Maxime Ripard <mripard@kernel.org> <maxi
 Mayuresh Janorkar <mayur@ti.com>
 Michael Buesch <m@bues.ch>
 Michel D=C3=A4nzer <michel@tungstengraphics.com>
+Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
+Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
+Mike Rapoport <rppt@kernel.org> <rppt@linux.ibm.com>
 Miodrag Dinic <miodrag.dinic@mips.com> <miodrag.dinic@imgtec.com>
 Miquel Raynal <miquel.raynal@bootlin.com> <miquel.raynal@free-electrons.co=
m>
 Mitesh shah <mshah@teja.com>
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-unneeded-includes-of-asm-pgalloch.patch
mm-remove-unneeded-includes-of-asm-pgalloch-fix.patch
opeinrisc-switch-to-generic-version-of-pte-allocation.patch
xtensa-switch-to-generic-version-of-pte-allocation.patch
asm-generic-pgalloc-provide-generic-pmd_alloc_one-and-pmd_free_one.patch
asm-generic-pgalloc-provide-generic-pud_alloc_one-and-pud_free_one.patch
asm-generic-pgalloc-provide-generic-pgd_free.patch
mm-move-lib-ioremapc-to-mm.patch
mm-sparse-cleanup-the-code-surrounding-memory_present.patch
mm-vmalloc-remove-redundant-asignmnet-in-unmap_kernel_range_noflush.patch

