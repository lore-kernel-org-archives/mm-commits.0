Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF56AC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD51A6120A
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbhKICfj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06EA360FC1;
        Tue,  9 Nov 2021 02:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425173;
        bh=ud+BIaAcuHO0IzVASnGZRKip2xmxMY8Eu0h1T4BsDUk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=duxlFSX+UxywsUQUta4FsNPaW5tNhtqwIa8GCCvw7lnvTNhk6BDunmU+T45x/EzUw
         p6SpPr3IPetbYB8ayLRaYcoqc9lGRERSsl0qkbi190f3ry06bp0t0++UEWhcAffLsh
         6uMV3kjgFPl8JMdH4VsCZwWgbGjJtLnFLe8Zn9Aw=
Date:   Mon, 08 Nov 2021 18:32:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ebiederm@xmission.com,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 28/87] MAINTAINERS: add "exec & binfmt" section
 with myself and Eric
Message-ID: <20211109023252.kJ5ZhSNZt%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Subject: MAINTAINERS: add "exec & binfmt" section with myself and Eric

I'd like more continuity of review for the exec and binfmt (and ELF)
stuff.  Eric and I have been the most active lately, so list us as
reviewers.

Link: https://lkml.kernel.org/r/20211006180200.1178142-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/MAINTAINERS~maintainers-add-exec-binfmt-section-with-myself-and-eric
+++ a/MAINTAINERS
@@ -7037,6 +7037,20 @@ F:	include/trace/events/mdio.h
 F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
 
+EXEC & BINFMT API
+R:	Eric Biederman <ebiederm@xmission.com>
+R:	Kees Cook <keescook@chromium.org>
+F:	arch/alpha/kernel/binfmt_loader.c
+F:	arch/x86/ia32/ia32_aout.c
+F:	fs/*binfmt_*.c
+F:	fs/exec.c
+F:	include/linux/binfmts.h
+F:	include/linux/elf.h
+F:	include/uapi/linux/binfmts.h
+F:	tools/testing/selftests/exec/
+N:	asm/elf.h
+N:	binfmt
+
 EXFAT FILE SYSTEM
 M:	Namjae Jeon <linkinjeon@kernel.org>
 M:	Sungjong Seo <sj1557.seo@samsung.com>
_
