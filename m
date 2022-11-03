Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B756FC4332F
	for <mm-commits@archiver.kernel.org>; Thu,  3 Nov 2022 01:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKCBGV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBGU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 21:06:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30885265B
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 18:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4938B816D7
        for <mm-commits@vger.kernel.org>; Thu,  3 Nov 2022 01:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C09C433C1;
        Thu,  3 Nov 2022 01:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667437577;
        bh=7EEtUV0xjtP2dlqLAl9fD2m2PxjStt3yfdgKHsh2gvI=;
        h=Date:To:From:Subject:From;
        b=CvDUu7UeVlA3n57KNtCw1bQdXuQQ42ueAdHhuraNNlgTVBiXJXs+cIkYWGQz4CL33
         8+kdAT0v5017XTGcL+/a59htjlsgvOSCMt+IK+bYMM8geniAVD+UPDywkCd9EQ8mxD
         4wpR0gyfyh3Qcy5MvkKpCKk7ubZYYiqpXbDQztbQ=
Date:   Wed, 02 Nov 2022 18:06:16 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org,
        zhaogongyi@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-vm-add-local_configh-and-local_configmk-to-gitignore.patch added to mm-nonmm-unstable branch
Message-Id: <20221103010617.63C09C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests/vm: add local_config.h and local_config.mk to .gitignore
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-vm-add-local_configh-and-local_configmk-to-gitignore.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-vm-add-local_configh-and-local_configmk-to-gitignore.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Zhao Gongyi <zhaogongyi@huawei.com>
Subject: selftests/vm: add local_config.h and local_config.mk to .gitignore
Date: Thu, 3 Nov 2022 08:57:54 +0800

Add local_config.h and local_config.mk to .gitignore to avoid accidentally
checking it in.

Link: https://lkml.kernel.org/r/20221103005754.205420-1-zhaogongyi@huawei.com
Signed-off-by: Zhao Gongyi <zhaogongyi@huawei.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/vm/.gitignore~selftests-vm-add-local_configh-and-local_configmk-to-gitignore
+++ a/tools/testing/selftests/vm/.gitignore
@@ -34,3 +34,5 @@ memfd_secret
 soft-dirty
 split_huge_page_test
 ksm_tests
+local_config.h
+local_config.mk
_

Patches currently in -mm which might be from zhaogongyi@huawei.com are

selftests-vm-add-local_configh-and-local_configmk-to-gitignore.patch

