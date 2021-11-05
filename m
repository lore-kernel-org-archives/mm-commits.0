Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5FFC43217
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E14B6128E
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhKEUsj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233721AbhKEUsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97DE961288;
        Fri,  5 Nov 2021 20:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145158;
        bh=arL/+cT2vlehXCChqicxg5TPamvvbL+JCxEAl9Uo+/0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v220vfvDTHGQXE3mKza+W4s91dCPqNsN1sh8ceRe0CXo0nQexv32vXuz/CobMAhNT
         wq4f02ME5PUml//SMRvJia2VawD8kpcjR1e4KE0OguNO4cAxsPnNq2roQxsaJzV2C3
         eA4DLJzgxQLAQVnzHbD8DxBERkiQ4vP1l+VxEuoE=
Date:   Fri, 05 Nov 2021 13:45:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 216/262] MAINTAINERS: update SeongJae's email
 address
Message-ID: <20211105204558.9bWvBTLQv%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
