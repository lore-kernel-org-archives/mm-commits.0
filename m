Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA342CCA473
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 21:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349102AbiFOVWi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 17:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbiFOVWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 17:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E7CB868
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 14:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C56561038
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 21:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DCAC3411A;
        Wed, 15 Jun 2022 21:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655328155;
        bh=ypd2Iw/59crIVNU+FC8Ip2SLk+rMs9Xg6YClBTgNyjI=;
        h=Date:To:From:Subject:From;
        b=Ag54QvcS2tprAzXa1cmREtaQMShm/UZ3HRPRC9gaRH6An8KkDvhKk+0TEIOipiSK+
         vwEVE7D0o4h8Im0Bw3Bm3OlRViML36cWUeG+mvQrvnqCcXkOgVbhYx5bZ0gN9W+Li3
         o/Ug+rUBt3rZSpVnp1s7XfnrXXhyZ+bdjrnhnds0=
Date:   Wed, 15 Jun 2022 14:22:34 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, gregkh@linuxfoundation.org, david@redhat.com,
        osalvador@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220615212235.94DCAC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Oscar Salvador <osalvador@suse.de>
Subject: maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix
Date: Wed, 15 Jun 2022 06:03:31 +0200

Link: https://lkml.kernel.org/r/YqlaE/LYHwB0gpaW@localhost.localdomain
Cc: David Hildenbrand <david@redhat.com>
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

maintainers-add-memory-hotunplug-section-and-add-myself-as-reviewer-fix.patch

