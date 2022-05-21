Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2EDC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 21 May 2022 15:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbiEUP1y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 21 May 2022 11:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245231AbiEUP1B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 21 May 2022 11:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9415E3A1B4
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 08:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E993B802C8
        for <mm-commits@vger.kernel.org>; Sat, 21 May 2022 15:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4052C385A5;
        Sat, 21 May 2022 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653146818;
        bh=rcejnnl2gsP6ee6N/LczzlP77oRjACSNAHwLPEi4oj8=;
        h=Date:To:From:Subject:From;
        b=Q/ipgNLtT3iEyrzlVA/XtbozDbrvmocmZX86Du0PUNwvD0touI9uVTfn8Hyaleqgj
         AWof8KHAx9d/0hj47eUGI7YMffBZb4QW2XYpp/Ye0XPsvNiGF/B1KAXfcKRhUs333I
         zsOpkX3bOGTpF4skL/K6cZ2D8m94spkkd+GEu4+0=
Date:   Sat, 21 May 2022 08:26:56 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-migration-to-the-gitignore.patch added to mm-unstable branch
Message-Id: <20220521152657.E4052C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: add migration to the .gitignore
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-vm-add-migration-to-the-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-migration-to-the-gitignore.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: vm: add migration to the .gitignore
Date: Sat, 21 May 2022 14:43:13 +0500

Add newly added migration test object to .gitignore file.

Link: https://lkml.kernel.org/r/20220521094313.166505-1-usama.anjum@collabora.com
Fixes: 0c2d08728470 ("mm: add selftests for migration entries")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-migration-to-the-gitignore
+++ a/tools/testing/selftests/vm/.gitignore
@@ -9,6 +9,7 @@ map_hugetlb
 map_populate
 thuge-gen
 compaction_test
+migration
 mlock2-tests
 mrelease_test
 mremap_dontunmap
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-vm-add-migration-to-the-gitignore.patch

