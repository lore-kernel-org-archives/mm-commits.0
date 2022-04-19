Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33367C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 05:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiDSFFx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Apr 2022 01:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbiDSFFt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Apr 2022 01:05:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F34140AB
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 22:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9171B810FD
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 05:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B05EC385A5;
        Tue, 19 Apr 2022 05:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650344585;
        bh=yzgqkSzz+jqVTiHsg4Mi+mry6OdgzT8Holg8Nc8yo0g=;
        h=Date:To:From:Subject:From;
        b=VQ+POOjMeaW9JB8aCRwarc6EmIppo3ki9FU8G+cWsYWs8HydIcfcEXfisLOTBGY/B
         W6xoXHAl8FBRMvTERADJjO0+LeZAjefbEK6gAPf5uhdnFcIoUADDsRslVxdl/y7IpX
         bTzXWd8h3vtpHpu19V+KH5EzGu5qTosXAbDV8o9k=
Date:   Mon, 18 Apr 2022 22:03:05 -0700
To:     mm-commits@vger.kernel.org, void@manifault.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, chris@chrisdown.name, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-corresponding-kselftests-to-cgroup-entry.patch added to -mm tree
Message-Id: <20220419050305.9B05EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add corresponding kselftests to cgroup entry
has been added to the -mm tree.  Its filename is
     maintainers-add-corresponding-kselftests-to-cgroup-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-corresponding-kselftests-to-cgroup-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-corresponding-kselftests-to-cgroup-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add corresponding kselftests to cgroup entry

List cgroup kselftests in the cgroup MAINTAINERS entry.  These are tests
covering core, freezer and cgroup.kill functionality.

Link: https://lkml.kernel.org/r/20220415000133.3955987-4-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
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

kselftests-memcg-update-the-oom-group-leaf-events-test.patch
kselftests-memcg-speed-up-the-memoryhigh-test.patch
maintainers-add-corresponding-kselftests-to-cgroup-entry.patch
maintainers-add-corresponding-kselftests-to-memcg-entry.patch
mm-do-not-call-add_nr_deferred-with-zero-deferred.patch

