From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mmotm:master 138/210] drivers/gpu/drm/msm/msm_drv.c:781:19:
 error: 'q' undeclared here (not in a function)
Date: Tue, 2 Aug 2016 19:09:56 -0700
Message-ID: <20160802190956.2c2ca13f8b5fb806d2179ebe__36143.990912433$1470190657$gmane$org@linux-foundation.org>
References: <201608031019.rRyFjE6p%fengguang.wu@intel.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbcHCCRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 22:17:23 -0400
In-Reply-To: <201608031019.rRyFjE6p%fengguang.wu@intel.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Linux Memory Management List <linux-mm@kvack.org>, mmotm auto import <mm-commits@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>

On Wed, 3 Aug 2016 10:01:36 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.cmpxchg.org/linux-mmotm.git master
> head:   572b7c98f12bd2213553be42cc5c2cbc5698f5c3
> commit: 4cceb4d7a297fcaec3527e355e6881850fc50ed3 [138/210] linux-next-git-rejects
> config: arm64-defconfig (attached as .config)
> compiler: aarch64-linux-gnu-gcc (Debian 5.4.0-6) 5.4.0 20160609
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 4cceb4d7a297fcaec3527e355e6881850fc50ed3
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64 
> 
> All error/warnings (new ones prefixed by >>):
> 
> >> drivers/gpu/drm/msm/msm_drv.c:781:19: error: 'q' undeclared here (not in a function)
>         DRIVER_PRIME |q

That's me being a twit.  This will go away in the next linux-next.
