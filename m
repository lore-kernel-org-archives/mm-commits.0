Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B762CC4743F
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F0561208
	for <mm-commits@archiver.kernel.org>; Mon,  7 Jun 2021 20:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhFGUnV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Jun 2021 16:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhFGUnV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Jun 2021 16:43:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A53861182;
        Mon,  7 Jun 2021 20:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623098480;
        bh=nkefQRDH2YFSCB4QIeXkdZE+JBtuUknp/eBezLzs60Y=;
        h=Date:From:To:Subject:From;
        b=RBXHm2UORkZhcbrzwF8PA7xwqaqXTHC73upD+Zo269D/1WIN6j4KL7otTN62w0lsk
         kGp8VrHYEy725alPeG9weltQR6TTmEB7D/r7/DfskGOx4Te0AduBGcvoU0x+yHu8a8
         p42c1Ijdu759mBSvrapzOHZdV9s6wu0iPQt95Els=
Date:   Mon, 07 Jun 2021 13:41:20 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, christian.brauner@ubuntu.com,
        dmatlack@google.com, gladkov.alexey@gmail.com,
        mm-commits@vger.kernel.org, shuah@kernel.org
Subject:  [merged]
 proc-add-gitignore-for-proc-subset-pid-selftest.patch removed from -mm tree
Message-ID: <20210607204120.jhGlb5QPC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: add .gitignore for proc-subset-pid selftest
has been removed from the -mm tree.  Its filename was
     proc-add-gitignore-for-proc-subset-pid-selftest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Matlack <dmatlack@google.com>
Subject: proc: add .gitignore for proc-subset-pid selftest

This new selftest needs an entry in the .gitignore file otherwise git
will try to track the binary.

Link: https://lkml.kernel.org/r/20210601164305.11776-1-dmatlack@google.com
Fixes: 268af17ada5855 ("selftests: proc: test subset=pid")
Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/.gitignore |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/proc/.gitignore~proc-add-gitignore-for-proc-subset-pid-selftest
+++ a/tools/testing/selftests/proc/.gitignore
@@ -10,6 +10,7 @@
 /proc-self-map-files-002
 /proc-self-syscall
 /proc-self-wchan
+/proc-subset-pid
 /proc-uptime-001
 /proc-uptime-002
 /read
_

Patches currently in -mm which might be from dmatlack@google.com are


