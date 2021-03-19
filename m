Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B99C433C1
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 15:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B77E61952
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 15:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhCSPpf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230283AbhCSPpB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 11:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C13861955;
        Fri, 19 Mar 2021 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616168700;
        bh=mSB7XCquEottb1VGTRT8C4FAI3ssHc2JqOprXyJcxJU=;
        h=Date:From:To:Subject:From;
        b=gCboZqbbxhh8RmiTnRhcyMUFIGn3a0yO60InnBI6F5PYdfoejGGVGhI/3/C54NVym
         ATpDdSetYp6ciXZB8l0LNyCNA9oBWar/YKo5/vTu0BkLK20Fv796yQ03jGKNaTMg7p
         36MGM4+Hy3sAu+XBC+jSV2MHhX4W6grNenHIY7GU=
Date:   Fri, 19 Mar 2021 08:45:00 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
 removed from -mm tree
Message-ID: <20210319154500.xbfAlmast%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
has been removed from the -mm tree.  Its filename was
     mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix

reflow comment

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mmzone.h~mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix
+++ a/include/linux/mmzone.h
@@ -436,9 +436,9 @@ enum zone_type {
 	 *    situations where ZERO_PAGE(0) which is allocated differently
 	 *    on different platforms may end up in a movable zone. ZERO_PAGE(0)
 	 *    cannot be migrated.
-	 * 7. Memory-hotplug: when using memmap_on_memory and onlining the memory
-	 *    to the MOVABLE zone, the vmemmap pages are also placed in such
-	 *    zone. Such pages cannot be really moved around as they are
+	 * 7. Memory-hotplug: when using memmap_on_memory and onlining the
+	 *    memory to the MOVABLE zone, the vmemmap pages are also placed in
+	 *    such zone. Such pages cannot be really moved around as they are
 	 *    self-stored in the range, but they are treated as movable when
 	 *    the range they describe is about to be offlined.
 	 *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

