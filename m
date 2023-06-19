Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF8E5EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjFSXUp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjFSXUa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:20:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561BC1BE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:20:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB12E60F39
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9B3C433C8;
        Mon, 19 Jun 2023 23:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216828;
        bh=c6poPp9J29DC7sFjsDh2V3uYsBE5BtgJTb4a6J/HmCU=;
        h=Date:To:From:Subject:From;
        b=V+Vs/cscpV1XFay0bLycQG7lJoYdcobVGBShxtT3t7KGbibcNmCX0UGqyodl2qleW
         Vzka6SplPs7Jx2u8A/P4IA7jDUh5K83G0GP3Wo/mhMNPA3Dq8e8if0n4MldgrXgGZ6
         gH8KffKdH2yNSNVoOsqfdRGQdIIRDf8yvChSgGcM=
Date:   Mon, 19 Jun 2023 16:20:27 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        shuah@kernel.org, peterx@redhat.com, nathan@kernel.org,
        david@redhat.com, corbet@lwn.net, jhubbard@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch removed from -mm tree
Message-Id: <20230619232028.2D9B3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests/mm: .gitignore: add mkdirty, va_high_addr_switch
has been removed from the -mm tree.  Its filename was
     selftests-mm-gitignore-add-mkdirty-va_high_addr_switch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: selftests/mm: .gitignore: add mkdirty, va_high_addr_switch
Date: Tue, 6 Jun 2023 00:16:31 -0700

These new build products were left out of .gitignore, so add them now.

Link: https://lkml.kernel.org/r/20230606071637.267103-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/mm/.gitignore~selftests-mm-gitignore-add-mkdirty-va_high_addr_switch
+++ a/tools/testing/selftests/mm/.gitignore
@@ -40,3 +40,5 @@ local_config.mk
 ksm_functional_tests
 mdwe_test
 gup_longterm
+mkdirty
+va_high_addr_switch
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


