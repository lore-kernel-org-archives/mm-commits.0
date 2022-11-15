Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25C6C43219
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiKOWc1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbiKOWcC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:32:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EE02BFD
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:32:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E10ECE1841
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDA5C433C1;
        Tue, 15 Nov 2022 22:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551517;
        bh=k5vW1Nl7tCxRGBoeXZPkZntsp0TvfxTzQrgyr0c/JQw=;
        h=Date:To:From:Subject:From;
        b=clz9M13JDaqoH0l+hhRZBWwN25tZE0L1eDTKDuQuBbg09Nj0O8iEsDucGA5yJYvw0
         w3IZq/iC5nTivGxX0LieR0dL2PHHa8PsYtI5wMZIhXjJnvvmbBssRyVd+KOU9EjH3G
         BOIa4TXyxLrF0QWApXkpuL883FzV1vi4NUmQiOC8=
Date:   Tue, 15 Nov 2022 14:31:57 -0800
To:     mm-commits@vger.kernel.org, pvorel@suse.cz,
        conor.dooley@microchip.com, chrubis@suse.cz, palmer@rivosinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-git-github-https-githubcom-for-linux-test-project.patch removed from -mm tree
Message-Id: <20221115223157.8DDA5C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: git://github -> https://github.com for linux-test-project
has been removed from the -mm tree.  Its filename was
     maintainers-git-github-https-githubcom-for-linux-test-project.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Palmer Dabbelt <palmer@rivosinc.com>
Subject: MAINTAINERS: git://github -> https://github.com for linux-test-project
Date: Thu, 13 Oct 2022 14:46:38 -0700

Github deprecated the git:// links about a year ago, so let's move to
the https:// URLs instead.

Link: https://lkml.kernel.org/r/20221013214638.30953-1-palmer@rivosinc.com
Reported-by: Conor Dooley <conor.dooley@microchip.com>
  Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-git-github-https-githubcom-for-linux-test-project
+++ a/MAINTAINERS
@@ -12090,7 +12090,7 @@ M:	Alexey Kodanev <alexey.kodanev@oracle
 L:	ltp@lists.linux.it (subscribers-only)
 S:	Maintained
 W:	http://linux-test-project.github.io/
-T:	git git://github.com/linux-test-project/ltp.git
+T:	git https://github.com/linux-test-project/ltp.git
 
 LYNX 28G SERDES PHY DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
_

Patches currently in -mm which might be from palmer@rivosinc.com are


