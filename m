Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97E5C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D494D61108
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhKKCv2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhKKCv2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:51:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 989F460F26;
        Thu, 11 Nov 2021 02:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598919;
        bh=0FUS46m1gusamJ+4scgokPcV9ckehHQniMXKWS3Y7sY=;
        h=Date:From:To:Subject:From;
        b=LgPEio7+SQkMcmq2B6FEdTYI7dOz3LZjDd2bFdmJSx1IJScGZjzcom2S8b3ZmLE1V
         JZ/py6vrzWifeaOYzATNM9/MplxG7Aarph59ACjm91iKQrDrItDTl7KRYH8tATiNUJ
         qEMCW++GnyRusN3HyHAgeW3bSgNv354WvOSY41es=
Date:   Wed, 10 Nov 2021 18:48:39 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, mm-commits@vger.kernel.org, sj@kernel.org,
        sjpark@amazon.de
Subject:  [merged] maintainers-update-seongjaes-email-address.patch
 removed from -mm tree
Message-ID: <20211111024839.uLjKAIB92%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update SeongJae's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-seongjaes-email-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS: update SeongJae's email address

This commit updates SeongJae's email address in MAINTAINERS file to his
preferred one.

Link: https://lkml.kernel.org/r/20210917123958.3819-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sjpark@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-seongjaes-email-address
+++ a/MAINTAINERS
@@ -5161,7 +5161,7 @@ F:	net/ax25/ax25_timer.c
 F:	net/ax25/sysctl_net_ax25.c
 
 DATA ACCESS MONITOR
-M:	SeongJae Park <sjpark@amazon.de>
+M:	SeongJae Park <sj@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/damon/
_

Patches currently in -mm which might be from sj@kernel.org are


