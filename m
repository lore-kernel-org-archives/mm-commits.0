Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB954C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbiEJEYx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiEJEXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECAE7646
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC9D61776
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7674C385A6;
        Tue, 10 May 2022 04:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156273;
        bh=MXy+RJa8VodlzF3WwZ2U1xNHX/NGEmSXU9m7EJdJ2kc=;
        h=Date:To:From:Subject:From;
        b=zwpiPay75VlRflAEWFV3X5FXcdPLR7odUeauIGkBUfsNcB+6Y/yTlp2JW2QeS32dw
         Y59piiiUyeJmoIKCHRuqxytx4wt2+i40foinPhzVY0s/l/9QEhDC7bh+kr3q4kL2VM
         5OxowQIFlf1nC6Nu9kYj9EntWStFyuHXDB4IliYw=
Date:   Mon, 09 May 2022 21:17:53 -0700
To:     mm-commits@vger.kernel.org, oleg@redhat.com,
        yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-remove-redundant-file-of-ptrace-support-entry.patch removed from -mm tree
Message-Id: <20220510041753.B7674C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: remove redundant file of PTRACE SUPPORT entry
has been removed from the -mm tree.  Its filename was
     maintainers-remove-redundant-file-of-ptrace-support-entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -15966,7 +15966,6 @@ F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
 F:	include/linux/regset.h
 F:	include/uapi/linux/ptrace.h
-F:	include/uapi/linux/ptrace.h
 F:	kernel/ptrace.c
 
 PULSE8-CEC DRIVER
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


