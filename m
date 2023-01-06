Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241F2C4708E
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 02:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjAFCgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 21:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjAFCf7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 21:35:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D241147D
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 18:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEFAEB81C1B
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 02:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68556C433D2;
        Fri,  6 Jan 2023 02:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672972552;
        bh=4NQCyLvuwZ6g5Nr1Yg+FduIB9U0gOntuAyTBfpDlMkU=;
        h=Date:To:From:Subject:From;
        b=bIBigpjefcC57u0/zzM3hRBk51HfRxBuPwDMI8vvcNI+qo/fAtvf8GTZc4WMqxpRA
         37/PVYTfR75NiCJCZrZ/8c6+fjAy8s9e8ceqhWbC6rQNW4vKeMq6LZ1+LuMvK5pw+V
         xLbtzprfWkKc3laASHe1h6f0evPmJoX+q/4hBXtM=
Date:   Thu, 05 Jan 2023 18:35:51 -0800
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-memory-management-add-tools-vm-as-managed-files.patch added to mm-unstable branch
Message-Id: <20230106023552.68556C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS/MEMORY MANAGEMENT: Add tools/vm/ as managed files
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-memory-management-add-tools-vm-as-managed-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-memory-management-add-tools-vm-as-managed-files.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS/MEMORY MANAGEMENT: Add tools/vm/ as managed files
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

mm-damon-core-implement-damos-filter.patch
mm-damon-paddr-support-damos-filters.patch
mm-damon-reclaim-add-a-parameter-called-skip_anon-for-avoiding-anonymous-pages-reclamation.patch
docs-admin-guide-damon-reclaim-document-skip_anon-parameter.patch
mm-damon-sysfs-schemes-implement-filters-directory.patch
mm-damon-sysfs-schemes-implement-filter-directory.patch
mm-damon-sysfs-schemes-connect-filter-directory-and-filters-directory.patch
mm-damon-sysfs-schemes-implement-scheme-filters.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix.patch
mm-damon-sysfs-schemes-implement-scheme-filters-fix-fix-2.patch
selftests-damon-sysfs-test-filters-directory.patch
docs-admin-guide-mm-damon-usage-document-damos-filters-of-sysfs.patch
docs-abi-damon-document-scheme-filters-files.patch
mm-page_reporting-replace-rcu_access_pointer-with-rcu_dereference_protected.patch
maintainers-add-types-to-akpm-mm-git-trees-entries.patch
maintainers-memory-management-add-tools-vm-as-managed-files.patch
tools-vm-rename-tools-vm-to-tools-mm.patch
selftests-vm-rename-selftets-vm-to-selftests-mm.patch
docs-admin-guide-mm-numaperf-increase-depth-of-subsections.patch
scripts-spelling-add-a-few-more-typos.patch

