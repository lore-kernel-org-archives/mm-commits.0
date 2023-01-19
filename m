Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CF4C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjASBUp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjASBTH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:19:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA9C69B35
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E4C161B08
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA90C433F2;
        Thu, 19 Jan 2023 01:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090979;
        bh=GiePevE6IN7eQxZHoKd4VY0c+5tZ9B76FLrfaIAn3+Y=;
        h=Date:To:From:Subject:From;
        b=OPdRtkIlGRqJY0kVhLNq/+hOBNsQQ3yvKNXdVLeaa5eq+Uhy0X5EDj2vDnPXuTBfV
         DmmrB+xU0lbVB+0JSLl8OXUJhl0j8rVlT4rVo8KmbMR/OubjfEwHCq+BH6OxLwWRs8
         YCJBvaevKHmx+m6MzTx8QpCXKiFylLbN10z4sA9I=
Date:   Wed, 18 Jan 2023 17:16:19 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-memory-management-add-tools-vm-as-managed-files.patch removed from -mm tree
Message-Id: <20230119011619.DCA90C433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS/MEMORY MANAGEMENT: add tools/vm/ as managed files
has been removed from the -mm tree.  Its filename was
     maintainers-memory-management-add-tools-vm-as-managed-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS/MEMORY MANAGEMENT: add tools/vm/ as managed files
Date: Tue, 3 Jan 2023 18:07:51 +0000

'tools/vm/' directory should be a part of memory management subsystem, but
MAINTAINERS file doesn't mark the directory so.  Add one more 'F:' entry
for the directory to 'MEMORY MANAGEMENT' section.

Link: https://lkml.kernel.org/r/20230103180754.129637-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-memory-management-add-tools-vm-as-managed-files
+++ a/MAINTAINERS
@@ -13484,6 +13484,7 @@ F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
 F:	mm/
 F:	tools/testing/selftests/vm/
+F:	tools/vm/
 
 VMALLOC
 M:	Andrew Morton <akpm@linux-foundation.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-update-kernel-doc-comments-for-damos-action-supports-of-each-damon-operations-set.patch
mm-damon-core-update-kernel-doc-comments-for-damos-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-index-mention-damos-on-the-intro.patch
docs-admin-guide-mm-damon-usage-update-damos-actions-filters-supports-of-each-damon-operations-set.patch
docs-mm-damon-add-a-maintainer-profile-for-damon.patch
maintainers-damon-link-maintainer-profile-git-trees-and-website.patch
selftests-damon-sysfs-hide-expected-write-failures.patch
selftests-damon-debugfs_rm_non_contexts-hide-expected-write-error-messages.patch
scripts-spelling-add-a-few-more-typos.patch

