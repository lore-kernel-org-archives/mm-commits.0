Return-Path: <SRS0=ssb3=BC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E1FC433E8
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 03:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 810C620723
	for <mm-commits@archiver.kernel.org>; Thu, 23 Jul 2020 03:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595474331;
	bh=+rDVkh7wamoqPSreleGlzRpgbl0Ucu89syoZ6SSqiiE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bELhbKlpcIVmhflN43kG1e8rjWoE+SzAKHueXidkJ/vAOwx38FcLUuqqMKp5O48NJ
	 t5FOy7TeUZvd8DdcoM9dFfx1bzpntZciImSvSHDxE1SOhPBVOO43dzaSRYZJmNJrcT
	 GTXwax/GvKwsA8OzoPl258ZM0yP1WKN1TLJ43vDU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgGWDSv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jul 2020 23:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbgGWDSv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 22 Jul 2020 23:18:51 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B3E320723;
        Thu, 23 Jul 2020 03:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595474329;
        bh=+rDVkh7wamoqPSreleGlzRpgbl0Ucu89syoZ6SSqiiE=;
        h=Date:From:To:Subject:From;
        b=oysyasZonoi8EPx5EbS9Vwqtpt9hYeidrlhaQAcFd9XkZVFx3LkwHNMEtPzQHqv39
         z/Ely95Ld7TjPUu5btTLZikEaGBZ0ZElR53QDbMB+cMHQ7R7Sg4+ShOop/EqiDXw/S
         YB0rf9YHDrmOwfMuLk6Pe3RvdJBbaMVSUxaTN5TE=
Date:   Wed, 22 Jul 2020 20:18:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20200723031848.bpjkLHFLX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/rt5670.c               |   15 ---------------
 sound/soc/intel/boards/cht_bsw_rt5672.c |   10 ----------
 sound/soc/soc-topology.c                |    3 ---
 3 files changed, 28 deletions(-)

--- a/sound/soc/codecs/rt5670.c~linux-next-git-rejects
+++ a/sound/soc/codecs/rt5670.c
@@ -30,11 +30,8 @@
 #include "rt5670.h"
 #include "rt5670-dsp.h"
 
-<<<<<<< HEAD
 #define RT5670_DEV_GPIO			BIT(0)
-=======
 #define RT5670_GPIO1_IS_IRQ			BIT(0)
->>>>>>> linux-next/akpm-base
 #define RT5670_IN2_DIFF			BIT(1)
 #define RT5670_DMIC_EN			BIT(2)
 #define RT5670_DMIC1_IN2P		BIT(3)
@@ -1457,11 +1454,7 @@ static int rt5670_spk_event(struct snd_s
 	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
 	struct rt5670_priv *rt5670 = snd_soc_component_get_drvdata(component);
 
-<<<<<<< HEAD
-	if (!rt5670->pdata.gpio1_is_ext_spk_en)
-=======
 	if (!rt5670->gpio1_is_ext_spk_en)
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	switch (event) {
@@ -3064,22 +3057,14 @@ static int rt5670_i2c_probe(struct i2c_c
 				   RT5670_GP1_PF_MASK, RT5670_GP1_PF_OUT);
 	}
 
-<<<<<<< HEAD
-	if (rt5670->pdata.gpio1_is_ext_spk_en) {
-=======
 	if (rt5670->gpio1_is_ext_spk_en) {
->>>>>>> linux-next/akpm-base
 		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL1,
 				   RT5670_GP1_PIN_MASK, RT5670_GP1_PIN_GPIO1);
 		regmap_update_bits(rt5670->regmap, RT5670_GPIO_CTRL2,
 				   RT5670_GP1_PF_MASK, RT5670_GP1_PF_OUT);
 	}
 
-<<<<<<< HEAD
-	if (rt5670->pdata.jd_mode) {
-=======
 	if (rt5670->jd_mode) {
->>>>>>> linux-next/akpm-base
 		regmap_update_bits(rt5670->regmap, RT5670_GLB_CLK,
 				   RT5670_SCLK_SRC_MASK, RT5670_SCLK_SRC_RCCLK);
 		rt5670->sysclk = 0;
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c~linux-next-git-rejects
+++ a/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -253,15 +253,6 @@ static int cht_codec_fixup(struct snd_so
 	params_set_format(params, SNDRV_PCM_FORMAT_S24_LE);
 
 	/*
-<<<<<<< HEAD
-	 * Default mode for SSP configuration is TDM 4 slot. One board/design,
-	 * the Lenovo Miix 2 10 uses not 1 but 2 codecs connected to SSP2. The
-	 * second piggy-backed, output-only codec is inside the keyboard-dock
-	 * (which has extra speakers). Unlike the main rt5672 codec, we cannot
-	 * configure this codec, it is hard coded to use 2 channel 24 bit I2S.
-	 * Since we only support 2 channels anyways, there is no need for TDM
-	 * on any cht-bsw-rt5672 designs. So we simply use I2S 2ch everywhere.
-=======
 	 * The default mode for the cpu-dai is TDM 4 slot. The default mode
 	 * for the codec-dai is I2S. So we need to either set the cpu-dai to
 	 * I2S mode to match the codec-dai, or set the codec-dai to TDM 4 slot
@@ -273,7 +264,6 @@ static int cht_codec_fixup(struct snd_so
 	 * 2 channel 24 bit I2S. For this to work we must use I2S mode on this
 	 * board. Since we only support 2 channels anyways, there is no need
 	 * for TDM on any cht-bsw-rt5672 designs. So we use I2S 2ch everywhere.
->>>>>>> linux-next/akpm-base
 	 */
 	ret = snd_soc_dai_set_fmt(asoc_rtd_to_cpu(rtd, 0),
 				  SND_SOC_DAIFMT_I2S     |
--- a/sound/soc/soc-topology.c~linux-next-git-rejects
+++ a/sound/soc/soc-topology.c
@@ -1263,10 +1263,7 @@ static int soc_tplg_dapm_graph_elems_loa
 
 		ret = soc_tplg_add_route(tplg, routes[i]);
 		if (ret < 0) {
-<<<<<<< HEAD
-=======
 			dev_err(tplg->dev, "ASoC: topology: add_route failed: %d\n", ret);
->>>>>>> linux-next/akpm-base
 			/*
 			 * this route was added to the list, it will
 			 * be freed in remove_route() so increment the
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
io-mapping-indicate-mapping-failure-fix.patch
mm-fix-kthread_use_mm-vs-tlb-invalidate-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
mmhwpoison-rework-soft-offline-for-in-use-pages-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

