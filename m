Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943F170826
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742283; cv=none; b=n0WAMhOiQ8Eev3RmNTKlPLfXgpzlIjLGGM7m7GbkUVtX8IjpWcpxlV6y6A/WWkUoAjGugtThi5qo0uwGy5vjHDmd/7zq5Ttnab4BmqDDLNVyaSjYctzb+UqheKdqP145+84Lqsk8iIVFR8/YU8ycQoXSKqn+fjyXbrfVo0ZOk6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742283; c=relaxed/simple;
	bh=v4fPN6vm8rnD7R4si8Q/L/AjwFDgAdI0fCQzK5jTqyQ=;
	h=Date:To:From:Subject:Message-Id; b=LqKwWGc3wbd9WlLR7+jIZs1v28g+7JFx1k0yQB3n+cakeejMPuFpNZ0vRkjDqc09Fs7tokB0gYPkU6TJl+OH3mCLsiZra/TvxG58b+ACbonOGF+WIGn9x/qLIRr18+69hizBLDqAr+s4XhRYhFjLpIHU2OEh5zZt0wo8pmtUQzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dgm1lOGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgm1lOGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F748C4CED6;
	Mon, 13 Jan 2025 04:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742283;
	bh=v4fPN6vm8rnD7R4si8Q/L/AjwFDgAdI0fCQzK5jTqyQ=;
	h=Date:To:From:Subject:From;
	b=dgm1lOGs+vU0qI+b3Vo7TVZZHvBRp0zUkh6Q1DRrBSeRh01zgqsl2dR8T4uPQVBtH
	 4XMAb42LCyJXT79PY14AFbIRPk3nNeIfCnATYOBPNSBY0TRIav52l9ss4LQ9YSLAUK
	 OJxEGOJG24/RmP1svG1H7f6ZbXB4FTbxxGWE5Us8=
Date: Sun, 12 Jan 2025 20:24:42 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,anupnewsmail@gmail.com,tanyaagarwal25699@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] credits-fix-spelling-mistakes.patch removed from -mm tree
Message-Id: <20250113042443.7F748C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: CREDITS: fix spelling mistake
has been removed from the -mm tree.  Its filename was
     credits-fix-spelling-mistakes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Subject: CREDITS: fix spelling mistake
Date: Sun, 12 Jan 2025 01:17:10 +0530

Fix spelling error identified using codespell tool.

Link: https://lkml.kernel.org/r/20250111194709.51133-1-tanyaagarwal25699@gmail.com
Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Cc: Anup Sharma <anupnewsmail@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/CREDITS~credits-fix-spelling-mistakes
+++ a/CREDITS
@@ -4327,7 +4327,7 @@ D: Freescale Highspeed USB device driver
 D: Freescale QE SoC support and Ethernet driver
 S: B-1206 Jingmao Guojigongyu
 S: 16 Baliqiao Nanjie, Beijing 101100
-S: People's Repulic of China
+S: People's Republic of China
 
 N: Vlad Yasevich
 E: vyasevich@gmail.com
_

Patches currently in -mm which might be from tanyaagarwal25699@gmail.com are


