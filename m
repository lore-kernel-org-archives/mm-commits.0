Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBCDC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbiFQCFe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiFQCFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:05:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8CD61633
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 701E161B7C
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5757C34114;
        Fri, 17 Jun 2022 02:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431530;
        bh=f3O1ENr2WHQcQzzvQP6rfzqqzSsNL4mvMrMF2Moesko=;
        h=Date:To:From:Subject:From;
        b=FkskPpPsJVIxOTETWfRQyMhjqrtRIoKOxJyHAcWmXJdOGF//DCItqAPcKg5sTmeI3
         jXRNZHI0tt69wq6waDy3IbeAwrNoLIhtnZ/1egs6IO8jgojUG2T6ZmpPF7q9rWKYZP
         hGK6iC/onLhdHqd/CXyZqvq9XnOnSx6ERWzO8Xrw=
Date:   Thu, 16 Jun 2022 19:05:29 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, gregkh@linuxfoundation.org, david@redhat.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix.patch removed from -mm tree
Message-Id: <20220617020530.C5757C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix
has been removed from the -mm tree.  Its filename was
     maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix.patch

This patch was dropped because it was folded into maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix
Date: Wed, 15 Jun 2022 06:03:31 +0200

Link: https://lkml.kernel.org/r/YqlaE/LYHwB0gpaW@localhost.localdomain
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix
+++ a/MAINTAINERS
@@ -12859,8 +12859,8 @@ F:	mm/
 F:	tools/testing/selftests/vm/
 
 MEMORY HOT(UN)PLUG
-M:	Andrew Morton <akpm@linux-foundation.org>
-R:	David Hildenbrand <david@redhat.com>
+M:	David Hildenbrand <david@redhat.com>
+M:	Oscar Salvador <osalvador@suse.de>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/memory-hotplug.rst
_

Patches currently in -mm which might be from osalvador@suse.de are

maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer.patch

