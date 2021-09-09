Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B31C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D8E161179
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:04:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346133AbhIIVFa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:05:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346067AbhIIVEY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:04:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5F88611C2;
        Thu,  9 Sep 2021 21:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221394;
        bh=XjBLmta16cQSsoMExoLDc0GiyxM7jXR39SHz+wx3IUc=;
        h=Date:From:To:Subject:From;
        b=phSDu6R/0xc3+Dv2OkBgECtCBRJrEoeLZKTLY3W1Ziv31h9NIO91FGC0PxnyhQu0j
         gHoHurFqD686VZo1V2DJPUuQqcJdV7EocUuXNdcoOBWUiBqJsDaMLZh0qRv0I/CfmI
         5S8ja9fkzpi1xcmnCde3yevscMFhuhDS63gFqsGo=
Date:   Thu, 09 Sep 2021 14:03:13 -0700
From:   akpm@linux-foundation.org
To:     alexander.shishkin@linux.intel.com, amit@kernel.org,
        benh@kernel.crashing.org, brendanhiggins@google.com,
        corbet@lwn.net, david@redhat.com, dwmw@amazon.com,
        elver@google.com, fan.du@intel.com, foersleo@amazon.de,
        greg@kroah.com, gthelen@google.com, joe@perches.com,
        Jonathan.Cameron@huawei.com, markubo@amazon.de, mgorman@suse.de,
        mheyne@amazon.de, minchan@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, namhyung@kernel.org,
        peterz@infradead.org, riel@surriel.com, rientjes@google.com,
        rostedt@goodmis.org, shakeelb@google.com, shuah@kernel.org,
        sieberf@amazon.com, sjpark@amazon.de, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [merged] maintainers-update-for-damon.patch removed from
 -mm tree
Message-ID: <20210909210313.K-XutSr6I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update for DAMON
has been removed from the -mm tree.  Its filename was
     maintainers-update-for-damon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: MAINTAINERS: update for DAMON

This commit updates MAINTAINERS file for DAMON related files.

Link: https://lkml.kernel.org/r/20210716081449.22187-14-sj38.park@gmail.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reviewed-by: Markus Boehme <markubo@amazon.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Fan Du <fan.du@intel.com>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Maximilian Heyne <mheyne@amazon.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/MAINTAINERS~maintainers-update-for-damon
+++ a/MAINTAINERS
@@ -5125,6 +5125,17 @@ F:	net/ax25/ax25_out.c
 F:	net/ax25/ax25_timer.c
 F:	net/ax25/sysctl_net_ax25.c
 
+DATA ACCESS MONITOR
+M:	SeongJae Park <sjpark@amazon.de>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/mm/damon/
+F:	Documentation/vm/damon/
+F:	include/linux/damon.h
+F:	include/trace/events/damon.h
+F:	mm/damon/
+F:	tools/testing/selftests/damon/
+
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 L:	netdev@vger.kernel.org
 S:	Orphan
_

Patches currently in -mm which might be from sjpark@amazon.de are


