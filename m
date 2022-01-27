Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4F5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 04:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiA0EHx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 23:07:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38584 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiA0EHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 23:07:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2174E617AE
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 04:07:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72421C340E4;
        Thu, 27 Jan 2022 04:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643256472;
        bh=ni88T0mMpVmwQRUvBvZPWGqVA8PdLF/WgKRGJlLBBSs=;
        h=Date:From:To:Subject:From;
        b=jT0oE1Y8LTRgGlsSaGViqS8wL2qmWw3CXtSsP4ZmmphLwC7SAd5PSB7JPIcGREa0O
         mWfzshau22sKc+kT3IigPsAbS8Cs6k+R926aoHVeHP8xzATuDG+8hYoxaE08EFetkg
         63qGl9fSHsVIi42JaYISeMVq/ZXp5MvF4sBIkLac=
Date:   Wed, 26 Jan 2022 20:07:51 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [failures]
 =?US-ASCII?Q?mm-migration-add-trace-events-for-base-page-and-hugetlb-migr?=
 =?US-ASCII?Q?ations-fix.patch?= removed from -mm tree
Message-ID: <20220127040751.IHPF7Ko-F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix
has been removed from the -mm tree.  Its filename was
     mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix

fix build

Link: https://lkml.kernel.org/r/53c3d1bb-7085-4947-772c-a3cbf94f02c8@arm.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations-fix
+++ a/mm/rmap.c
@@ -76,6 +76,7 @@
 
 #include <asm/tlbflush.h>
 
+#define CREATE_TRACE_POINTS
 #include <trace/events/tlb.h>
 #include <trace/events/migrate.h>
 
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch

