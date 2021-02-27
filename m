Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCB8C433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D28A164F3D
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhB0CdT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhB0Ccj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:32:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7689D64F49;
        Sat, 27 Feb 2021 02:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393119;
        bh=DHtw2sxIGuVcdJzH1KuvDZKnLoesjU/uG+9mzh//5+8=;
        h=Date:From:To:Subject:From;
        b=HyF8dEd/oro+vC276JwGUrKa5nEH/67WRSN65sG+0ITIOe2/YhxYhf0sFTTKIFxDM
         uHSPB9ZqXLuv5WYvPbLvIzVSNPVPBsdKEvC0L6dckP+goXp1o5/DLKN2GFhLUUSYyU
         b7zOx/FQBo8apmPR4yX8wIYS0GxcipB3LgmKfaEw=
Date:   Fri, 26 Feb 2021 18:31:59 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, vbabka@suse.cz
Subject:  [merged]
 maintainers-add-uapi-directories-to-api-abi-section.patch removed from -mm
 tree
Message-ID: <20210227023159.ssMrl9lrQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add uapi directories to API/ABI section
has been removed from the -mm tree.  Its filename was
     maintainers-add-uapi-directories-to-api-abi-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS: add uapi directories to API/ABI section

Let's add include/uapi/ and arch/*/include/uapi/ to API/ABI section, so
that for patches modifying them, get_maintainers.pl suggests CCing
linux-api@ so people don't forget.

Link: https://lkml.kernel.org/r/20210217174745.13591-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: David Hildenbrand <david@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-uapi-directories-to-api-abi-section
+++ a/MAINTAINERS
@@ -261,6 +261,8 @@ ABI/API
 L:	linux-api@vger.kernel.org
 F:	include/linux/syscalls.h
 F:	kernel/sys_ni.c
+F:	include/uapi/
+F:	arch/*/include/uapi/
 
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
_

Patches currently in -mm which might be from vbabka@suse.cz are


