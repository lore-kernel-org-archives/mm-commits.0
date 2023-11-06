Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A974CC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 16:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjKFQ3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 11:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjKFQ3k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 11:29:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15856A4
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 08:29:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7890C433C8;
        Mon,  6 Nov 2023 16:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699288177;
        bh=nEM6CETEGrs7yxziTTl2Qri8plR9vsxkpAVWq7OzF28=;
        h=Date:To:From:Subject:From;
        b=nkj4HRoK9hx8EQFuicNixJT0yIWZZr2aenUUHNatPBKLgIwhbBEbJ/F2EJsFIzBTb
         at1qDyEwx0aTZTAapS3WoayQvWVktVqU6fRgYjByFLvZ3aBcm8+3pTV2YKcFA8PnwO
         8lUNwjPT7gxJ4f6J42gM+OmCxL/ZzYEMohnVxLJA=
Date:   Mon, 06 Nov 2023 08:29:37 -0800
To:     mm-commits@vger.kernel.org, ryan.roberts@arm.com,
        leitao@debian.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch added to mm-hotfixes-unstable branch
Message-Id: <20231106162937.A7890C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/mm: add hugetlb_fault_after_madv to .gitignore
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch

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
From: Breno Leitao <leitao@debian.org>
Subject: selftests/mm: add hugetlb_fault_after_madv to .gitignore
Date: Fri, 3 Nov 2023 10:34:00 -0700

commit 116d57303a05 ("selftests/mm: add a new test for madv and hugetlb")
added a new test case, but, it didn't add the binary name in
tools/testing/selftests/mm/.gitignore.

Add hugetlb_fault_after_madv to tools/testing/selftests/mm/.gitignore.

Link: https://lkml.kernel.org/r/20231103173400.1608403-2-leitao@debian.org
Fixes: 116d57303a05 ("selftests/mm: add a new test for madv and hugetlb")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Closes: https://lore.kernel.org/all/662df57e-47f1-4c15-9b84-f2f2d587fc5c@arm.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-add-hugetlb_fault_after_madv-to-gitignore
+++ a/tools/testing/selftests/mm/.gitignore
@@ -45,3 +45,4 @@ mdwe_test
 gup_longterm
 mkdirty
 va_high_addr_switch
+hugetlb_fault_after_madv
_

Patches currently in -mm which might be from leitao@debian.org are

selftests-mm-restore-number-of-hugepages.patch
selftests-mm-add-hugetlb_fault_after_madv-to-gitignore.patch

