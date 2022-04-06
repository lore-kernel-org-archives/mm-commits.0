Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AE2C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 20:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiDFVAx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Apr 2022 17:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiDFU75 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Apr 2022 16:59:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0307E0981
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 12:26:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77B90B82545
        for <mm-commits@vger.kernel.org>; Wed,  6 Apr 2022 19:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359C5C385A1;
        Wed,  6 Apr 2022 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649273162;
        bh=M/9zLj5zhXiZF/29a68Npn2wg6PS46wUg4v2LgE6MTE=;
        h=Date:To:From:Subject:From;
        b=hoFRm2T2kVe6HQks+lnX/hkuWYQHRdgP76z6X+bk6xKfA67DjI9q7ebJSTnVGkw4U
         e24JeZZQlggYnXuxKrAwQdDnT+PkI7tiT1XRJ6rRR+FSS3iL3VSUF2wpi/1GsxR7sp
         u9+O8h+3OOVfThdJR779AQcpJjxXwfa6af8g7rM0=
Date:   Wed, 06 Apr 2022 12:26:01 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-redundant-file-of-ptrace-support-entry.patch added to -mm tree
Message-Id: <20220406192602.359C5C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove redundant file of PTRACE SUPPORT entry
has been added to the -mm tree.  Its filename is
     maintainers-remove-redundant-file-of-ptrace-support-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-redundant-file-of-ptrace-support-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-redundant-file-of-ptrace-support-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: MAINTAINERS: remove redundant file of PTRACE SUPPORT entry

In MAINTAINERS PTRACE SUPPORT entry, the file include/uapi/linux/ptrace.h
is redundant, remove it.

Link: https://lkml.kernel.org/r/1649240981-11024-4-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-remove-redundant-file-of-ptrace-support-entry
+++ a/MAINTAINERS
@@ -15959,7 +15959,6 @@ F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
 F:	include/linux/regset.h
 F:	include/uapi/linux/ptrace.h
-F:	include/uapi/linux/ptrace.h
 F:	kernel/ptrace.c
 
 PULSE8-CEC DRIVER
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

ptrace-remove-redudant-check-of-ifdef-ptrace_singlestep.patch
ptrace-fix-wrong-comment-of-pt_dtrace.patch
maintainers-remove-redundant-file-of-ptrace-support-entry.patch

