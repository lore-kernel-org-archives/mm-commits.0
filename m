Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE67C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbiEYRtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343527AbiEYRtD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B450B3E
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F16A461800
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FEFC385B8;
        Wed, 25 May 2022 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500941;
        bh=7m3e7ZcM+MuKfmvkrnKX80iRryBv0SKgMipQwRPPHuQ=;
        h=Date:To:From:Subject:From;
        b=NAVTFOwsdxKYSPKnxH2MXdPhIIm3CTIgoSSkfwZvge23rDuvWKp1fTOGN8ivDuoSR
         wcFQUB2eobbJYc3rc/Sr5IqL9DT+pusAaOdntUvt8p+lUJ66B5ixkzrEZ4sunXvmoB
         S7JdpRMhocAk4zs6H1mpzUcrlFvqgAqNzuVWWC5k=
Date:   Wed, 25 May 2022 10:49:00 -0700
To:     mm-commits@vger.kernel.org, apopple@nvidia.com,
        usama.anjum@collabora.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-vm-add-migration-to-the-gitignore.patch removed from -mm tree
Message-Id: <20220525174901.51FEFC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: vm: add migration to the .gitignore
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-migration-to-the-gitignore.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: vm: add migration to the .gitignore
Date: Sat, 21 May 2022 14:43:13 +0500

Add newly added migration test object to .gitignore file.

Link: https://lkml.kernel.org/r/20220521094313.166505-1-usama.anjum@collabora.com
Fixes: 0c2d08728470 ("mm: add selftests for migration entries")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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


