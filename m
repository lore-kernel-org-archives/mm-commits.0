Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F72FC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4968A61241
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhKKCuB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:50:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhKKCuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:50:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BB16103C;
        Thu, 11 Nov 2021 02:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598832;
        bh=t+1T/9n6Y1Fx6FIaRrN0iw4ijwRZVt+jWqkog6d1GaU=;
        h=Date:From:To:Subject:From;
        b=UdmFO3zRj2AqRZR5LWK5rMuY23XpTac8JbhuxGDUfsQDo86TYD3hY1hPX7TQP9svc
         +OM0vuUvp2Qb+Pl1Fh4pmgNvYxQQdze9XYGOC35mV6qFCbE9cbP5B3NCV8yG9oFUen
         kF0p6mg0K2LWwTXwUZvFmaqmwHAblfFrr9psG5U0=
Date:   Wed, 10 Nov 2021 18:47:12 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de, rppt@linux.ibm.com
Subject:  [merged]
 memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch
 removed from -mm tree
Message-ID: <20211111024712.nFvCULgpZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path
has been removed from the -mm tree.  Its filename was
     memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: memory-hotplug.rst: fix wrong /sys/module/memory_hotplug/parameters/ path

We accidentially added a superfluous "s".

Link: https://lkml.kernel.org/r/20210930144117.23641-3-david@redhat.com
Fixes: ac3332c44767 ("memory-hotplug.rst: complete admin-guide overhaul")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/memory-hotplug.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/memory-hotplug.rst~memory-hotplugrst-fix-wrong-sys-module-memory_hotplug-parameters-path
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -410,7 +410,7 @@ them with ``memory_hotplug.`` such as::
 
 and they can be observed (and some even modified at runtime) via::
 
-	/sys/modules/memory_hotplug/parameters/
+	/sys/module/memory_hotplug/parameters/
 
 The following module parameters are currently defined:
 
_

Patches currently in -mm which might be from david@redhat.com are


