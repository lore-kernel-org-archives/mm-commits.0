Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52E1C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 03:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjBXDBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 22:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjBXDBr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 22:01:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5735D478
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:01:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83E57CE22A3
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 03:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8270C433EF;
        Fri, 24 Feb 2023 03:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677207699;
        bh=/TsQf5kmm0kYZSGoujXEMKoupg/n1Q5Gs+CMQfDXAfA=;
        h=Date:To:From:Subject:From;
        b=TNFyuAmC+wcNqcuHinQI7OyWYUd7hVt8P1jQQr4Sid+diqE+QDqFS0+bik+F1Yu1i
         UPxVgau6WMYdB20vWqNaf0o70vwfRMF1Bri79tA1GD/KIFcVQfW6OQ2nHndfVuA5jq
         8gRyWgitNJgfhsu7LAWAO1uMk/5d2bn2EyAoB7MU=
Date:   Thu, 23 Feb 2023 19:01:39 -0800
To:     mm-commits@vger.kernel.org, rdunlap@xenotime.net, joe@perches.com,
        gregkh@linuxfoundation.org, corbet@lwn.net,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] submitting-patchesrst-suggest-a-link-after-reported-by.patch removed from -mm tree
Message-Id: <20230224030139.A8270C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: submitting-patches.rst: suggest a Link: after Reported-by:
has been removed from the -mm tree.  Its filename was
     submitting-patchesrst-suggest-a-link-after-reported-by.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: submitting-patches.rst: suggest a Link: after Reported-by:
Date: Thu Feb 23 05:41:49 PM PST 2023

It seems to be the new way and I find it super useful.

Cc: Joe Perches <joe@perches.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/process/submitting-patches.rst~submitting-patchesrst-suggest-a-link-after-reported-by
+++ a/Documentation/process/submitting-patches.rst
@@ -501,6 +501,12 @@ the bug was reported in private, then as
 Reported-by tag. The tag is intended for bugs; please do not use it to credit
 feature requests.
 
+Where possible, please include a Link: to the report on the line
+immediately following the Reported-by:.  For example,
+
+Reported-by: John Doe <john.doe@gmail.com>
+  Link: https://lkml.kernel.org/r/02f796c7@gmail.com
+
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that
 some testing has been performed, provides a means to locate testers for
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch

