Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087F9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiEJEPU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiEJEOn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:14:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9B71159
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:10:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0ACE615DA
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD0DC385A6;
        Tue, 10 May 2022 04:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155845;
        bh=q+clYv5RKLy/1twRyIyTNpvUjaHKeUiIlUofSP9objw=;
        h=Date:To:From:Subject:From;
        b=m1ATJiIGDfQuucNh/HLUljMymT/Iv3Suaoa81pG9eYUr2VoMU9hosRJW7WSkt/rvL
         pdWJMda3ENo0e1ZbW2oh7tA9Ywbu6hB5TDtigBnnVLpg0E+sl8/XXV7Sjy92+uIbiY
         lcRHyMH9dHvzaIsqNsG4GK6/R4z5J6e+1ehfAtpI=
Date:   Mon, 09 May 2022 21:10:44 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-corresponding-kselftests-to-cgroup-entry.patch removed from -mm tree
Message-Id: <20220510041045.3DD0DC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add corresponding kselftests to cgroup entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-corresponding-kselftests-to-cgroup-entry.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add corresponding kselftests to cgroup entry

List cgroup kselftests in the cgroup MAINTAINERS entry.  These are tests
covering core, freezer and cgroup.kill functionality.

Link: https://lkml.kernel.org/r/20220415000133.3955987-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Vernet <void@manifault.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-corresponding-kselftests-to-cgroup-entry
+++ a/MAINTAINERS
@@ -4993,6 +4993,7 @@ F:	Documentation/admin-guide/cgroup-v1/
 F:	Documentation/admin-guide/cgroup-v2.rst
 F:	include/linux/cgroup*
 F:	kernel/cgroup/
+F:	tools/testing/selftests/cgroup/
 
 CONTROL GROUP - BLOCK IO CONTROLLER (BLKIO)
 M:	Tejun Heo <tj@kernel.org>
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are


