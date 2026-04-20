Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24478244661
	for <mm-commits@vger.kernel.org>; Mon, 20 Apr 2026 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701265; cv=none; b=BlyvXl4HhwuIbcOvDaepa6VGca8Vw+BuC3gk4cP5GfpBlcVk1cyOmvmYBaVIe1IRalifmfxGHo+5pUYAfasdsQ98+BqWEY6/tHwUSjV0id+GgrSIv8UPgJANfd5JVIdj9x640TSYhae4sfI6++zj0SJ7D7dT9Od6kpL77AduIEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701265; c=relaxed/simple;
	bh=+/L7FTDCrWD1Asu2hq7XilmyZRVo7kHnHq6QkIVkVq0=;
	h=Date:To:From:Subject:Message-Id; b=RExmsPL59gv9imlck9QKl6c84dpfmZbu9lFNY2zz7sAHTvLVgSK6oy6hfO7hoObJlvaK8Hzr3aseL+WjSw6D7olGSRQ8+NRLXLgguT1ekIXN1HTe4zvk85hlRA+S7uvbCg7PMCZaaD3pWUVgSlxvpbNOyrUiranV0H4bZDUtmxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1aUbSH9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1aUbSH9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E5EC2BCB4;
	Mon, 20 Apr 2026 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776701265;
	bh=+/L7FTDCrWD1Asu2hq7XilmyZRVo7kHnHq6QkIVkVq0=;
	h=Date:To:From:Subject:From;
	b=1aUbSH9meCEqmCs9u87/rItaxNwY9bah0uUdBeDrEoYihZc3lpZLIOVMvoY8QOMv1
	 oVPl2XvZgqVDWPfX5tHmz7xSiHn2EDsOvZWAXY7NieFGi9td692R09315rQGJfAtXb
	 wAW30wgyMW3PiUe4vQxv3QO4v05cewRfohj8iLug=
Date: Mon, 20 Apr 2026 09:07:42 -0700
To: mm-commits@vger.kernel.org,error27@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-dan-carpenter.patch added to mm-hotfixes-unstable branch
Message-Id: <20260420160744.94E5EC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Dan Carpenter
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-dan-carpenter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-dan-carpenter.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Dan Carpenter <error27@gmail.com>
Subject: mailmap: update entry for Dan Carpenter
Date: Mon, 20 Apr 2026 18:15:50 +0300

Update my mailmap entry to point to my current email address.

Link: https://lore.kernel.org/ab2d502542c24491c191a76494717c340afb9a9b.1776691831.git.error27@gmail.com
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-entry-for-dan-carpenter
+++ a/.mailmap
@@ -203,6 +203,7 @@ Claudiu Beznea <claudiu.beznea@tuxon.dev
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
+Dan Carpenter <error27@gmail.com> <dan.carpenter@linaro.org>
 Dan Carpenter <error27@gmail.com> <dan.carpenter@oracle.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@iogearbox.net>
_

Patches currently in -mm which might be from error27@gmail.com are

mailmap-update-entry-for-dan-carpenter.patch

